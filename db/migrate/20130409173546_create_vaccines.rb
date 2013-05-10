class CreateVaccines < ActiveRecord::Migration
  def change
    create_table :vaccines do |t|
      t.string :name
      t.string :vaccine_type
      t.text :description
      t.string :photo

      t.timestamps
    end
  end
end
