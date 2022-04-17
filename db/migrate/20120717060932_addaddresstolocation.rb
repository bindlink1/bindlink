class Addaddresstolocation < ActiveRecord::Migration
  def up
    add_column :locations, :location_nickname, :string
    add_column :locations, :address_1, :string
    add_column :locations, :address_2, :string
    add_column :locations, :city, :string
    add_column :locations, :state, :string
    add_column :locations, :zip, :string
    add_column :locations, :phone, :string
    add_column :locations, :fax, :string
  end

  def down
  end
end
