class Invoicechange < ActiveRecord::Migration
  def up
    rename_column :invoices, :policypremiumtransactions_id, :policypremiumtransaction_id
  end

  def down
  end
end
