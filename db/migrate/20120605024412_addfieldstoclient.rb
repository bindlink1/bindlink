class Addfieldstoclient < ActiveRecord::Migration
  def up
    add_column :clients, :contactname_1,:string
    add_column :clients, :contactname_2,:string
    add_column :clients, :contactname_3,:string
    add_column :clients, :home_phone,:string
    add_column :clients, :home_phone_2,:string
    add_column :clients, :cell_phone, :string
    add_column :clients, :cell_phone_2, :string
    add_column :clients, :fax_phone, :string
  end

  def down
  end
end
