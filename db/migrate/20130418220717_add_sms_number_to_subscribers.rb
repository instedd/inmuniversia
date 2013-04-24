class AddSmsNumberToSubscribers < ActiveRecord::Migration
  def change
    add_column :subscribers, :sms_number, :string
  end
end
