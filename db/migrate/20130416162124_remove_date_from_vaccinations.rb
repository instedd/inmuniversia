class RemoveDateFromVaccinations < ActiveRecord::Migration
  def up
    remove_column :vaccinations, :date
  end

  def down
    add_column :vaccinations, :date, :date
  end
end
