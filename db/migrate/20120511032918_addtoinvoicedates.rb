class Addtoinvoicedates < ActiveRecord::Migration
  def up
     add_column :invoices, :book_month,:integer
     add_column :invoices, :book_year,:integer
     add_column :cashtransactions, :book_month,:integer
     add_column :cashtransactions, :book_year,:integer
  end

  def down
  end
end
