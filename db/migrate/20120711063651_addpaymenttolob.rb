class Addpaymenttolob < ActiveRecord::Migration
  def up
    add_column :lobcommissions, :billing_type, :integer
  end

  def down
  end
end
