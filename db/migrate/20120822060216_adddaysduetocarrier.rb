class Adddaysduetocarrier < ActiveRecord::Migration
  def up
    add_column :carriers, :days_invoice_due, :integer
  end

  def down
  end
end
