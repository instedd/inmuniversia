class ChangeDefaultValueToEmailOnSubscribers < ActiveRecord::Migration
  def up
    change_column :subscribers, :email, :string, :default => nil, :null => true
  end

  def down
    change_column :subscribers, :email, :string, :default => "", :null => false
  end
end
