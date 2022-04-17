class Addfeetypestofee < ActiveRecord::Migration
  def up
    add_column :fees, :fee_remit_type, :string
  end

  def down
    add_column :fees, :fee_remit_type, :string
  end
end
