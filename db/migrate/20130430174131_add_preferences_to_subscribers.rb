class AddPreferencesToSubscribers < ActiveRecord::Migration
  def change
    add_column :subscribers, :preferences, :text
  end
end
