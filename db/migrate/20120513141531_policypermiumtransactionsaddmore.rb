class Policypermiumtransactionsaddmore < ActiveRecord::Migration
  def up
    add_column :policypremiumtransactions, :transaction_type ,:string
    add_column :policypremiumtransactions, :book_month ,:integer
    add_column :policypremiumtransactions, :book_year ,:integer
  end

  def down
  end
end
