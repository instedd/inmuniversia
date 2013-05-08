# This migration comes from refinery_vaccines (originally 2)
class CreateVaccinesDiseases < ActiveRecord::Migration

  def up
    create_table :refinery_vaccines_diseases do |t|
      t.string :name
      t.text :description
      t.integer :photo_id
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
