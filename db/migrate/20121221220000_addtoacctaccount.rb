class Addtoacctaccount < ActiveRecord::Migration
  def up
    add_column :accountingaccounts, :contra_account_id, :integer
    rename_column :accountingaccounts, :account_Id, :acount_id

  end

  def down
  end
end
