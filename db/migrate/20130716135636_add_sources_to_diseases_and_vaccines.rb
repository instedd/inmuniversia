class AddSourcesToDiseasesAndVaccines < ActiveRecord::Migration
  def change
    add_column :refinery_vaccines, :sources, :text
    add_column :refinery_vaccines_diseases, :sources, :text
  end
end
