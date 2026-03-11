class CreateEmergencies < ActiveRecord::Migration[8.1]
  def change
    create_table :emergencies do |t|
      t.timestamps
    end
  end
end
