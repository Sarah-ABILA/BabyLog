class CreateVaccinations < ActiveRecord::Migration[8.1]
  def change
    create_table :vaccinations do |t|
      t.references :user_baby, null: false, foreign_key: true
      t.string :name
      t.date :injection_date
      t.boolean :status, default: false

      t.timestamps
    end
  end
end
