class ChangeRemindersSentAtToDateTime < ActiveRecord::Migration
  def up
    change_column :reminders, :sent_at, :datetime
  end

  def down
    change_column :reminders, :sent_at, :date
  end
end
