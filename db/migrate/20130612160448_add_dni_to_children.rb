class AddDniToChildren < ActiveRecord::Migration
  def change
    add_column :children, :dni, :int
  end
end
