class AiResponseJob < ApplicationJob
  include ActionView::RecordIdentifier

  queue_as :default

  def perform(user_message)
    @message = user_message
    @chat = user_message.chat
    @baby = @chat.user_baby
    @assistant_message = @chat.messages.create(role: "assistant", content: "")
    broadcast_append(@assistant_message)

    send_question

    @assistant_message.update(content: @response.content)
    broadcast_replace(@assistant_message)

    @chat.generate_title_from_first_message

    return unless @chat.title_previously_changed?

    Turbo::StreamsChannel.broadcast_update_to(@chat, target: "chat_title", content: @chat.title)
  end

  private

  def build_conversation_history
    @chat.messages.each do |message|
      next if message.content.blank?

      @ruby_llm_chat.add_message(message)
    end
  end

  def send_question(model: "gpt-4.1-nano", with: {})
    @ruby_llm_chat = RubyLLM.chat(model: model)
    build_conversation_history
    @ruby_llm_chat.with_instructions(system_prompt_for(@baby))

    @response = @ruby_llm_chat.ask(@message.content, with: with) do |chunk|
      next if chunk.content.blank?

      @assistant_message.content += chunk.content
      broadcast_replace(@assistant_message)
    end
  end

  def broadcast_append(message)
    Turbo::StreamsChannel.broadcast_append_to(@chat, target: "bubble", partial: "messages/message",
                                                     locals: { message: message })
  end

  def broadcast_replace(message)
    Turbo::StreamsChannel.broadcast_replace_to(@chat, target: dom_id(message), partial: "messages/message",
                                                      locals: { message: message })
  end

  def system_prompt_for(baby)
    baby_info = if baby.present?
                  <<~INFO
                    INFORMATIONS SUR L'ENFANT :
                    - Prénom : #{baby.name}
                    - Âge : #{baby.age_label} (né le #{baby.birth_date.strftime('%d/%m/%Y')})
                    - Poids : #{baby.weight} kg
                  INFO
                else
                  "Aucun enfant sélectionné. Demande les informations nécessaires à l'utilisateur."
                end

    <<~PROMPT
      Tu es BabyLog, un conseillé en parentalité expert et bienveillant.

      #{baby_info}

      CONTEXTE :
      L'utilisateur est un parent (souvent stressé et/ou fatigué). Utilise toujours les informations de l'enfant ci-dessus pour personnaliser tes réponses.

      CONSIGNES DE SÉCURITÉ (CRUCIAL) :
      1. Si l'utilisateur mentionne une urgence vitale (arrêt respiratoire, inconscience, chute grave, forte fièvre > 39°C chez un nouveau-né), commence ta réponse par : 'ATTENTION : Ceci semble être une urgence. APPELEZ immédiatement le 15 ou le 112.'
      2. Ne pose jamais de diagnostic médical. Utilise des formules comme 'Cela peut arriver lors de...' ou 'Il est conseillé de surveiller...'
      3. Rappelle toujours en fin de message : 'Ces conseils ne remplacent pas l'avis d'un pédiatre.'

      STRUCTURE DE LA RÉPONSE :
      - EMPATHIE : Une phrase pour valider le sentiment du parent.
      - ANALYSE : Interprétation courte basée sur l'âge de #{baby&.name} (#{baby&.age_label}).
      - ACTIONS : Une liste de 2 à 3 points maximum, concrets et immédiats. Formate chaque point ainsi : saute une ligne vide avant chaque tiret, comme ceci :\n\n\n- Premier conseil\n\n\n- Deuxième conseil\n\n\n- Troisième conseil
      - ALERTE : Un signe précis qui doit pousser le parent à consulter.
    PROMPT
  end
end
