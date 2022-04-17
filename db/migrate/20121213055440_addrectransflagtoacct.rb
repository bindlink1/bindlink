class Addrectransflagtoacct < ActiveRecord::Migration
  def up
    add_column :accountingtransactions, :reconcile_flag, :string
  end

  def down
  end
end
