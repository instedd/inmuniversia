class RenameDoseOrderToNumber < ActiveRecord::Migration
  def change
    rename_column :doses, :order, :number
  end
end
