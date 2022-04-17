class Addpolicyidtoal3trans < ActiveRecord::Migration
  def up
  add_column :al3transactions, :policy_id, :integer
  end

  def down
  end
end
