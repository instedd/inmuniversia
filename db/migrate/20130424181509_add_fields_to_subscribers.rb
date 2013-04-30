class AddFieldsToSubscribers < ActiveRecord::Migration
  def change
    add_column :subscribers, :first_name, :string
    add_column :subscribers, :last_name, :string
    add_column :subscribers, :zip_code, :string
  end
end
