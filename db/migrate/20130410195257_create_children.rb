class CreateChildren < ActiveRecord::Migration
  def change
    create_table :children do |t|
      t.string :name
      t.date :date_of_birth
      t.string :gender
      t.integer :parent_id

      t.timestamps
    end

    add_index :children, :parent_id
  end
end
