class AddFieldsToRefineryVaccinesDiseases < ActiveRecord::Migration
  def change
    add_column :refinery_vaccines_diseases, :incidence_info, :text
    add_column :refinery_vaccines_diseases, :geographical_distribution, :text
    add_column :refinery_vaccines_diseases, :high_risk_groups, :text
    add_column :refinery_vaccines_diseases, :rate_info, :text
  end
end
