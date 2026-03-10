class MessagesController < ApplicationController
  before_action :authenticate_user!
  SYSTEM_PROMPT = "Tu es BabyLog, un conseillé en parentalité expert et bienveillant, ton rôle est :

CONTEXTE :
L'utilisateur est un parent (souvent stressé et/ou fatigué). Tu reçois des informations sur un enfant (âge, poids, antécédents) et une question ou un symptôme.

CONSIGNES DE SÉCURITÉ (CRUCIAL) :
1. Si l'utilisateur mentionne une urgence vitale (arrêt respiratoire, inconscience, chute grave, forte fièvre > 39°C chez un nouveau-né), commence ta réponse par : ':rotating_light: ATTENTION : Ceci semble être une urgence. Appelez immédiatement le 15 ou le 112.'
2. Ne pose jamais de diagnostic médical définitif. Utilise des formules comme 'Cela peut arriver lors de...' ou 'Il est conseillé de surveiller...'
3. Rappelle toujours en fin de message : 'Ces conseils ne remplacent pas l'avis d'un pédiatre.'

STRUCTURE DE LA RÉPONSE :
- EMPATHIE : Une phrase pour valider le sentiment du parent (ex: 'Il est normal de s'inquiéter quand bébé ne finit pas ses biberons').
- ANALYSE : Interprétation courte basée sur l'âge de l'enfant.
- ACTIONS : Une liste de 3 points maximum, concrets et immédiats.
- ALERTE : Un signe précis qui doit pousser le parent à consulter (ex: 'Consultez si la fièvre persiste plus de 48h')."

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = 'user'

    if @message.save
      begin
        # Correction : Utilisation d'une méthode plus simple pour l'historique
        @ruby_llm_chat = RubyLLM.chat.with_instructions(SYSTEM_PROMPT)

        # On ajoute les anciens messages à l'IA pour qu'elle ait de la mémoire
        @chat.messages.where.not(id: @message.id).each do |msg|
          @ruby_llm_chat.add_message(role: msg.role, content: msg.content)
        end

        # On pose la question avec le contenu du nouveau message
        response = @ruby_llm_chat.ask(@message.content)

        # Sauvegarde de la réponse de l'IA
        Message.create!(content: response.content, role: "assistant", chat: @chat)

        # Mise à jour du titre si c'est le premier message
        @chat.generate_title_from_first_message
      rescue RubyLLM::RateLimitError
        # On crée un message d'erreur "fictif" de l'assistant pour informer l'utilisateur
        Message.create!(
          chat: @chat,
          role: "assistant",
          content: "Désolé, je suis un peu surchargé en ce moment. Peux-tu réessayer dans une minute ?"
        )
      rescue StandardError => e
        # Optionnel : log de l'erreur pour le debug si ce n'est pas un RateLimit
        logger.error "Erreur IA: #{e.message}"
      end

      redirect_to chat_path(@chat)
    else
      @messages = @chat.messages
      render "chats/show", status: :unprocessable_entity
    end
  end

  private

  def build_conversation_history
    @chat.messages.each do |message|
      @ruby_llm_chat.add_message(message)
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end

  def set_message
    @message = Chat.find(params[:id])
  end

  def instructions
    [SYSTEM_PROMPT, chat_context, @chat.system_prompt].compact.join("\n\n")
  end
end
