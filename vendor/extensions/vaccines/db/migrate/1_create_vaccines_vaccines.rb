class CreateVaccinesVaccines < ActiveRecord::Migration

  def up
    create_table :refinery_vaccines do |t|
      t.string :name
      t.text :general_info
      t.text :commercial_name
      t.text :doses_info
      t.text :recommendations
      t.text :side_effects
      t.text :more_info
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
      ::Refinery::Page.delete_all({:link_url => "/vaccines/vaccines"})
    end

    drop_table :refinery_vaccines

  end

end
