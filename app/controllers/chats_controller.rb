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
    @chat = Chat.new
    @chat.user = current_user
    @chat.user_baby_id = params[:user_baby_id]
    @chat.persona = params[:persona]
    @chat.title = Chat::DEFAULT_TITLE
    if @chat.save
      redirect_to chat_path(@chat)
    else
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
