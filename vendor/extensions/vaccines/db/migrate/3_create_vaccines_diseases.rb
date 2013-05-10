class CreateVaccinesDiseases < ActiveRecord::Migration

  def up
    create_table :refinery_vaccines_diseases do |t|
      t.string :name
      t.text :incidence_info
      t.text :geographical_distribution
      t.text :high_risk_groups
      t.text :rate_info
      t.boolean :published
      t.integer :position

      t.timestamps
    end

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-vaccines"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/vaccines/diseases"})
    end

    drop_table :refinery_vaccines_diseases

  end

end
