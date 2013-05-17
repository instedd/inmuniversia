class AddSmsOnlyFieldToSubscriber < ActiveRecord::Migration
  def change
    add_column :subscribers, :sms_only, :boolean, :default => false
  end
end
