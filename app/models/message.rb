class Message < ApplicationRecord
  validates :content, presence: true, unless: :assistant? # Dernière virgule pour dire que l'ia commence sans content.
  validates :role, presence: true
  validates :role, inclusion: { in: %w[user assistant] }

  validate :user_message_limit, if: -> { role == "user" }
  MAX_USER_MESSAGES = 10
  belongs_to :chat

  # Broadcasts pour Turbo Stream
  broadcasts_to :chat

  def user?
    role == "user"
  end

  def assistant?
    role == "assistant"
  end

  def user_message_limit
    return unless chat.messages.where(role: "user").count >= MAX_USER_MESSAGES

    errors.add(:content, "You can only send #{MAX_USER_MESSAGES} messages per chat.")
  end
end
