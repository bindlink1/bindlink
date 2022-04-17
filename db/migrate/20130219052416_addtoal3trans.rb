class Addtoal3trans < ActiveRecord::Migration
  def up
    add_column :al3transactions, :cycle_business_purpose, :string
  end

  def down
  end
end
