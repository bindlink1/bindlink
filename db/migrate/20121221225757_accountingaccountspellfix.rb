class Accountingaccountspellfix < ActiveRecord::Migration
  def up
    rename_column :accountingaccounts, :acount_id, :account_id
  end

  def down
  end
end
