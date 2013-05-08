class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :type
      t.references :subscriber
      t.string :address
      t.boolean :notifications_enabled
      t.string :verification_code

      t.timestamps
    end
    add_index :channels, :subscriber_id
  end
end
