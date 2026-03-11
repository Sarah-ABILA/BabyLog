class AddDoctorToUserBabies < ActiveRecord::Migration[8.1]
  def change
    add_column :user_babies, :doctor, :string
  end
end
