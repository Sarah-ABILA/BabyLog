class CreateUserBabies < ActiveRecord::Migration[8.1]
  def change
    create_table :user_babies do |t|
      t.timestamps
    end
  end
end
