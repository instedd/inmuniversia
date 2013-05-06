class RemoveFieldsFromRefineryVaccinesDiseases < ActiveRecord::Migration
  def up
    remove_column :refinery_vaccines_diseases, :description
    remove_column :refinery_vaccines_diseases, :photo_id
  end

  def down
    add_column :refinery_vaccines_diseases, :photo_id, :integer
    add_column :refinery_vaccines_diseases, :description, :text
  end
end
