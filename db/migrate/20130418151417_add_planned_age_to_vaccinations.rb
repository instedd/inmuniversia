class AddPlannedAgeToVaccinations < ActiveRecord::Migration
  def change
    add_column :vaccinations, :planned_age_value, :integer
    add_column :vaccinations, :planned_age_unit, :string

    rename_column :vaccinations, :planned_date, :planned_fixed_date
  end
end
