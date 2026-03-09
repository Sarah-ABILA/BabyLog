class CreateResults < ActiveRecord::Migration[8.1]
  def change
    create_table :results do |t|
      t.timestamps
    end
  end
end
