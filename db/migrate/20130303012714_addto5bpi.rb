class Addto5bpi < ActiveRecord::Migration
  def up
    add_column :al3h5bpis, :nominal_term_amount, :decimal
    add_column :al3h5bpis, :written_amount, :decimal

  end

  def down
  end
end
