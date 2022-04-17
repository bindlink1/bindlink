class Accountingtransactionsaddpolicyid < ActiveRecord::Migration
  def up
    add_column :accountingtransactions, :policy_id ,:integer
  end

  def down
  end
end
