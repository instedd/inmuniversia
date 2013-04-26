class AddNumberToReminder < ActiveRecord::Migration
  def change
    add_column :reminders, :number, :integer
  end
end
