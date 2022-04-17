class Addtranstypetofees < ActiveRecord::Migration
  def up
    add_column :fees, :transaction_type, :string
  end

  def down
  end
end
