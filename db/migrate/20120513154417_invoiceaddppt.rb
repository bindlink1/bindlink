class Invoiceaddppt < ActiveRecord::Migration
  def up
    add_column :invoices, :policypremiumtransactions_id ,:integer
  end

  def down
  end
end
