class Policypermiumtransactionsadd < ActiveRecord::Migration
  def up
      add_column :policypremiumtransactions, :policy_id ,:integer
  end

  def down
  end
end
