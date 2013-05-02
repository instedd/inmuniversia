class RemoveFieldsFromRefineryVaccines < ActiveRecord::Migration
  def up
    remove_column :refinery_vaccines, :vaccine_type
    remove_column :refinery_vaccines, :description
    remove_column :refinery_vaccines, :photo_id
  end

  def down
    add_column :refinery_vaccines, :photo_id, :integer
    add_column :refinery_vaccines, :description, :text
    add_column :refinery_vaccines, :vaccine_type, :string
  end
end
