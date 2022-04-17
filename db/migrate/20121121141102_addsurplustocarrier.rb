class Addsurplustocarrier < ActiveRecord::Migration
  def up
    add_column :carriers, :admitted_status, :string
  end

  def down
  end
end
