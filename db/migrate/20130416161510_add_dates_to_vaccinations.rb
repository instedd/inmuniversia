class AddDatesToVaccinations < ActiveRecord::Migration
  def change
    add_column :vaccinations, :planned_date, :date
    add_column :vaccinations, :taken_at, :datetime
  end
end
