class CreateDoses < ActiveRecord::Migration
  def change
    create_table :doses do |t|
      t.integer :age_value
      t.string :age_unit
      t.integer :order
      t.string :name
      t.integer :interval_value
      t.string :interval_unit
      t.string :type
      t.integer :vaccine_id

      t.timestamps
    end

    add_index :doses, :vaccine_id
  end
end
