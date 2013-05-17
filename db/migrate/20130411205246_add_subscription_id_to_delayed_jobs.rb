class AddSubscriptionIdToDelayedJobs < ActiveRecord::Migration
  def change
    add_column :delayed_jobs, :subscription_id, :integer
    add_index :delayed_jobs, :subscription_id
  end
end
