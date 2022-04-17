class Transactiontypetocash < ActiveRecord::Migration
  def up
    add_column :cashtransactions, :transaction_type, :string

  end

  def down
  end
end
