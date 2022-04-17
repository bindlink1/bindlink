class CreateInvoiceitems < ActiveRecord::Migration
  def change
    create_table :invoiceitems do |t|
      t.integer :invoice_id
      t.decimal :total_billed
      t.decimal :commission
      t.decimal :fees
      t.decimal :taxes
      t.timestamps
    end
  end
end
