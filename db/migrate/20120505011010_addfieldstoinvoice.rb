class Addfieldstoinvoice < ActiveRecord::Migration
  def up

      add_column :invoices, :total_billed, :decimal
     add_column :invoices, :commission, :decimal
     add_column :invoices, :fees, :decimal
     add_column :invoices, :taxes, :decimal

  end

  def down
  end
end
