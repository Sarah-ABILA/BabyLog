class ChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat, only: %i[show]
  def index
    @chats = current_user.chats
  end

  def show
    @chat = current_user.chats.find(params[:id])
    @message = Message.new
    @result = Result.new
    @messages = @chat.messages
  end

  def new
    @chat = Chat.new
  end

  def create
    # On crée le chat en passant les paramètres autorisés (qui incluent user_baby_id)
    @chat = current_user.chats.build(chat_params)
    @chat.user = current_user
    @chat.title = Chat::DEFAULT_TITLE # Assure-toi que cette constante existe dans ton modèle Chat

    if @chat.save
      # On redirige vers le chat spécifique qui vient d'être créé
      redirect_to chat_path(@chat)
    else
      # Si ça échoue, on retourne à la sélection
      @user_babies = current_user.user_babies
      render "pages/home", status: :unprocessable_entity
    end
  end

  def destroy
    @chat = current_user.chats.find(params[:id])
    @chat.destroy
    redirect_to chats_path, notice: "Conversation supprimée"
  end

  private

  def set_chat
    @chat = Chat.find(params[:id])
  end

  def chat_params
    params.permit(:title, :user_baby_id, :persona)
  end
end
