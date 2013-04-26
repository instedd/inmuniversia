class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.references :vaccination
      t.string :type
      t.date :sent_at
      t.string :status

      t.timestamps
    end
    add_index :reminders, :vaccination_id
  end
end
