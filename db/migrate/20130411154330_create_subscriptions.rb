class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :vaccine
      t.references :child
      t.string :status

      t.timestamps
    end
    add_index :subscriptions, :vaccine_id
    add_index :subscriptions, :child_id
  end
end
