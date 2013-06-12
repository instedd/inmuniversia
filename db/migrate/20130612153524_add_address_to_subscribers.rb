class AddAddressToSubscribers < ActiveRecord::Migration
  def change
    add_column :subscribers, :address, :string
  end
end
