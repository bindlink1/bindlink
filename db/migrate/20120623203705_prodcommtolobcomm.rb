class Prodcommtolobcomm < ActiveRecord::Migration
  def up
    add_column :lobcommissions, :producer_rate, :decimal
  end

  def down
  end
end
