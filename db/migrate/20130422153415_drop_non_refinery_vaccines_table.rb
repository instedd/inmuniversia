class DropNonRefineryVaccinesTable < ActiveRecord::Migration
  def up
    drop_table :vaccines if connection.table_exists? :vaccines
  end

  def down
    create_table :vaccines do |t|
      t.string   "name"
      t.string   "vaccine_type"
      t.text     "description"
      t.string   "photo"
      t.datetime "created_at",   :null => false
      t.datetime "updated_at",   :null => false
    end
  end
end
