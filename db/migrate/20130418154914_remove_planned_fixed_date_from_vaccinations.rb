class RemovePlannedFixedDateFromVaccinations < ActiveRecord::Migration
  def up
    remove_column :vaccinations, :planned_fixed_date
  end

  def down
    add_column :vaccinations, :planned_fixed_date, :date
  end
end
