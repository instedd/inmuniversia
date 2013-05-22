class ChangeFieldsOnComments < ActiveRecord::Migration
  def up
    add_column :comments, :subscriber_id, :integer, :default => 0, :null => false
    remove_column :comments, :user_id
  end

  def down
    remove_column :comments, :subscriber_id
    add_column :comments, :user_id, :integer, :default => 0, :null => false
  end
end
