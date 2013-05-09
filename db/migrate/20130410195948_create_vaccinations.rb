class CreateVaccinations < ActiveRecord::Migration
  def change
    create_table :vaccinations do |t|
      t.integer :child_id
      t.integer :dose_id
      t.integer :vaccine_id
      t.date :date

      t.timestamps
    end

    add_index :vaccinations, :child_id
    add_index :vaccinations, :dose_id
    add_index :vaccinations, :vaccine_id
  end
end
