class AddStatusToVaccinations < ActiveRecord::Migration
  def change
    add_column :vaccinations, :status, :string
  end
end
