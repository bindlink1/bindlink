class Addaddresstonamedins < ActiveRecord::Migration
  def up
    add_column :namedinsureds, :address_1, :string
    add_column :namedinsureds, :address_2, :string
    add_column :namedinsureds, :city, :string
    add_column :namedinsureds, :state, :string
    add_column :namedinsureds, :zip, :string
  end

  def down
  end
end
