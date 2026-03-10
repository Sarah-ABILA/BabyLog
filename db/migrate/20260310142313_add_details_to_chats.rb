class AddDetailsToChats < ActiveRecord::Migration[8.1]
  def change
    add_column :chats, :persona, :string
    add_column :chats, :title, :string
    add_reference :chats, :user, null: false, foreign_key: true
  end
end
