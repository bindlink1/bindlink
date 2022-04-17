class Invoicedescriptionadd < ActiveRecord::Migration
  def up
    add_column :invoices, :description ,:string
  end

  def down
  end
end
