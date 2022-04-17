class CreateAccountingtransactions < ActiveRecord::Migration
  def change
    create_table :accountingtransactions do |t|
      t.integer :account_id
      t.integer :invoice_id
      t.integer :invoice_item_id
      t.decimal :amount
      t.date :transaction_date
      t.timestamps
    end
  end
end
