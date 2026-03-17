class AddAgeToVaccinations < ActiveRecord::Migration[8.1]
  def change
    add_column :vaccinations, :age, :integer
  end
end
