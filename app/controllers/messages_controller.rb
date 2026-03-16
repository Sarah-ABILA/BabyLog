class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @baby = @chat.user_baby
    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = 'user'

    if @message.save
      # Déléguer la réponse IA au job SolidQueue
      AiResponseJob.perform_now(@chat.id, @baby.id)
      raise
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to chat_path(@chat) }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("turbo-chat", partial: "messages/form",
                                                                 locals: { chat: @chat, message: Message.new })
        end
        format.html { render "chats/show", status: :unprocessable_entity }
      end
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

  def message_params
    params.require(:message).permit(:content)
  end
end
