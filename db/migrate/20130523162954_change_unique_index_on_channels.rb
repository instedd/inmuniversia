class ChangeUniqueIndexOnChannels < ActiveRecord::Migration
  def up
    remove_index :channels, :name => "index_channels_on_address"
    add_index :channels, [:address, :verification_code], :unique => true, :name => "index_channels_on_address_and_verification_code"
  end

  def down
    remove_index :channels, :name => "index_channels_on_address_and_verification_code"
    add_index :channels, :address, :unique => true, :name => "index_channels_on_address"
  end
end
