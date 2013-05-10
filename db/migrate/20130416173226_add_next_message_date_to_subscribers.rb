class AddNextMessageDateToSubscribers < ActiveRecord::Migration
  def change
    add_column :subscribers, :next_message_at, :date
  end
end
