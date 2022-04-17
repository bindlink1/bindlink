class Addpaymentttolobcomm < ActiveRecord::Migration
  def up
    add_column :lineofbusinesses, :billing_type, :integer
  end

  def down
  end
end
