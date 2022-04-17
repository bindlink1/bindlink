class Addtoinvoice < ActiveRecord::Migration
  def up
    add_column :invoices, :base_premium,:decimal
    add_column :invoices, :down_payment,:decimal
    add_column :invoices, :comm_fees,:decimal
    add_column :invoices, :non_comm_fees,:decimal
  end

  def down
  end
end
