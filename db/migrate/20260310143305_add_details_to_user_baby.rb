class AddDetailsToUserBaby < ActiveRecord::Migration[8.1]
  def change
    add_reference :user_babies, :user, null: false, foreign_key: true
    add_column :user_babies, :name, :string
    add_column :user_babies, :birth_date, :date
    add_column :user_babies, :weight, :decimal
    add_column :user_babies, :avatar, :string
  end
end
