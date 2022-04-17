class Addtoal3transmore < ActiveRecord::Migration
  def up
    add_column :al3transactions, :al3h2trg_id, :integer
    add_column :al3transactions, :transaction_effective_date, :date
  end

  def down
  end
end
