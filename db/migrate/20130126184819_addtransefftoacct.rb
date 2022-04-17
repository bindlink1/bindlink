class Addtransefftoacct < ActiveRecord::Migration
  def up
    add_column :accountingtransactions, :book_date, :date
    add_column :accountingtransactions, :transaction_effective_date , :date
    remove_column :accountingtransactions, :transaction_date
    add_column :accountingtransactions, :effective_month, :integer
    add_column :accountingtransactions, :effective_year, :integer
    add_column :policypremiumtransactions, :effective_month, :integer
    add_column :policypremiumtransactions, :effective_year, :integer

    add_column :cashtransactions, :transaction_effective_date , :date
    add_column :cashtransactions, :book_date, :date
    add_column :cashtransactions, :effective_month, :integer
    add_column :cashtransactions, :effective_year, :integer




  end

  def down
  end
end
