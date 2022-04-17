class Addrenewaltolobcommission < ActiveRecord::Migration
  def up
    add_column :lobcommissions, :commission_rate_renew, :decimal
  end

  def down
  end
end
