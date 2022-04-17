class CreateAccountingaccounts < ActiveRecord::Migration
  def change
    create_table :accountingaccounts do |t|
      t.integer :account_Id
      t.text :account_name
      t.text :balance_sheet
      t.timestamps
    end
  end
end
