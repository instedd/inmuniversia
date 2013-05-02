class ChangeFieldsInDiseases < ActiveRecord::Migration
  
  def up
    remove_column :refinery_vaccines_diseases, :incidence_info
    remove_column :refinery_vaccines_diseases, :geographical_distribution
    remove_column :refinery_vaccines_diseases, :high_risk_groups
    remove_column :refinery_vaccines_diseases, :rate_info

    add_column :refinery_vaccines_diseases, :summary, :text
    add_column :refinery_vaccines_diseases, :transmission, :text
    add_column :refinery_vaccines_diseases, :diagnosis, :text
    add_column :refinery_vaccines_diseases, :treatment, :text
    add_column :refinery_vaccines_diseases, :statistics, :text
  end

  def down
    add_column :refinery_vaccines_diseases, :incidence_info, :text
    add_column :refinery_vaccines_diseases, :geographical_distribution, :text
    add_column :refinery_vaccines_diseases, :high_risk_groups, :text
    add_column :refinery_vaccines_diseases, :rate_info, :text
    
    remove_column :refinery_vaccines_diseases, :summary
    remove_column :refinery_vaccines_diseases, :transmission
    remove_column :refinery_vaccines_diseases, :diagnosis
    remove_column :refinery_vaccines_diseases, :treatment
    remove_column :refinery_vaccines_diseases, :statistics
  end

end
