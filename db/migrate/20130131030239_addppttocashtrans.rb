class Addppttocashtrans < ActiveRecord::Migration
  def up
    add_column :cashtransactions, :policypremiumtransaction_id, :integer
  end

  def down
  end
end
