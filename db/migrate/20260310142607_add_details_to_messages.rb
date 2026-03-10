class AddDetailsToMessages < ActiveRecord::Migration[8.1]
  def change
    add_reference :messages, :chat, null: false, foreign_key: true
    add_column :messages, :content, :text
    add_column :messages, :role, :string
  end
end
