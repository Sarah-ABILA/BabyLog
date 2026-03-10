class AddDetailsToResults < ActiveRecord::Migration[8.1]
  def change
    add_reference :results, :chat, null: false, foreign_key: true
    add_column :results, :roadmap, :text
  end
end
