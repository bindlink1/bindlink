class CreateCashtransactions < ActiveRecord::Migration
  def change
    create_table :cashtransactions do |t|
      t.integer :invoice_id
      t.decimal :cash_amount
      t.string :payment_type
      t.timestamps
    end
  end
end
