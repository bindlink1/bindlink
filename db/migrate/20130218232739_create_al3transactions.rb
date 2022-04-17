class CreateAl3transactions < ActiveRecord::Migration
  def change
    create_table :al3transactions do |t|
      t.integer :al3file_id
      t.string :transaction_function
      t.integer :carrier_id
      t.date :transaction_date
      t.timestamps
    end
  end
end
