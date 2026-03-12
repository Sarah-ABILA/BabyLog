class AddUserBabyToChats < ActiveRecord::Migration[8.1]
  def change
    add_reference :chats, :user_baby, null: false, foreign_key: true
  end
end
