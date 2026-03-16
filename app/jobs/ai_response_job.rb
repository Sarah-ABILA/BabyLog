# app/jobs/ai_response_job.rb
class AiResponseJob < ApplicationJob
  queue_as :default

  def perform(chat_id, baby_id)
    chat = Chat.find(chat_id)
    baby = UserBaby.find(baby_id)

    # Créer le message assistant vide
    assistant_message = chat.messages.create!(
      role: "assistant",
      content: ""
    )

    full_content = ""

    begin
      ruby_llm_chat = RubyLLM.chat.with_instructions(system_prompt_for(baby))

      # Recharger l'historique (sans le dernier message user qui sera passé via ask)
      messages = chat.messages.where(role: ["user", "assistant"])
                     .where.not(id: assistant_message.id)
                     .order(:created_at)

      last_user_message = messages.where(role: "user").last
      previous_messages = messages.where.not(id: last_user_message.id)

      previous_messages.each do |msg|
        ruby_llm_chat.add_message(role: msg.role, content: msg.content)
      end

      # Stream token par token
      ruby_llm_chat.ask(last_user_message.content) do |chunk|
        full_content += chunk.content

        Turbo::StreamsChannel.broadcast_update_to(
          chat,
          target: "message_#{assistant_message.id}",
          partial: "messages/message",
          locals: { message: assistant_message.tap { |m| m.content = full_content } }
        )
      end

      assistant_message.update!(content: full_content)
      chat.generate_title_from_first_message
    rescue RubyLLM::RateLimitError
      assistant_message.update!(
        content: "Désolé, je suis un peu surchargé en ce moment. Peux-tu réessayer dans une minute ?"
      )
      Turbo::StreamsChannel.broadcast_update_to(
        chat,
        target: "message_#{assistant_message.id}",
        partial: "messages/message",
        locals: { message: assistant_message }
      )
    rescue StandardError => e
      Rails.logger.error "Erreur IA: #{e.message}"
      assistant_message.update!(content: "Une erreur est survenue, merci de réessayer.")
    end
  end

  private

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
