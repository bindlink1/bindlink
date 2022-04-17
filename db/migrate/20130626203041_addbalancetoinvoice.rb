class Addbalancetoinvoice < ActiveRecord::Migration
  def up
    add_column :invoices, :current_balance, :decimal
  end

  def down
  end
end
