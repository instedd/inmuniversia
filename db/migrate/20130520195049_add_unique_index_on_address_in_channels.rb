class AddUniqueIndexOnAddressInChannels < ActiveRecord::Migration
  def change
    add_index :channels, :address, :unique => true, :name => "index_channels_on_address"
  end
end
