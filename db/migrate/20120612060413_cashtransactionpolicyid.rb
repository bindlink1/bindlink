class Cashtransactionpolicyid < ActiveRecord::Migration
  def up
    add_column :cashtransactions, :policy_id, :integer
  end

  def down
  end
end
