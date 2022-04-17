class Earnedfee < ActiveRecord::Migration
  def up
    rename_column :fees, :transaction_type, :earn_type
  end

  def down
  end
end
