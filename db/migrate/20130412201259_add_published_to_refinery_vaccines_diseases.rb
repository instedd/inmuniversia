class AddPublishedToRefineryVaccinesDiseases < ActiveRecord::Migration
  def change
    add_column :refinery_vaccines_diseases, :published, :boolean
  end
end
