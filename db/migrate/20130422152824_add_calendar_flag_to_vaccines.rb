class AddCalendarFlagToVaccines < ActiveRecord::Migration
  def up
    add_column :refinery_vaccines, :in_calendar, :boolean
  end

  def down
    remove_column :refinery_vaccines, :in_calendar
  end
end
