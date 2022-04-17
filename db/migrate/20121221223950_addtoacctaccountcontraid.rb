class Addtoacctaccountcontraid < ActiveRecord::Migration
  def up
    add_column :accountingaccounts, :contra_account_ref_id, :integer
  end

  def down
  end
end
