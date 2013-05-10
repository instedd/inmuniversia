class AddFieldsToRefineryVaccines < ActiveRecord::Migration
  def change
    add_column :refinery_vaccines, :general_info, :text
    add_column :refinery_vaccines, :commercial_name, :text
    add_column :refinery_vaccines, :doses_info, :text
    add_column :refinery_vaccines, :recommendations, :text
    add_column :refinery_vaccines, :side_effects, :text
    add_column :refinery_vaccines, :more_info, :text
    add_column :refinery_vaccines, :published, :boolean
  end
end
