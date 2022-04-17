class Addtoprospect < ActiveRecord::Migration
  def up
    add_column :prospects, :prospect_name,:string
    add_column :prospects, :agency_id,:integer
    add_column :prospects, :email,:string
    add_column :prospects, :contactname_1,:string
    add_column :prospects, :contactname_2,:string
    add_column :prospects, :contactname_3,:string
    add_column :prospects, :home_phone,:string
    add_column :prospects, :home_phone_2,:string
    add_column :prospects, :cell_phone, :string
    add_column :prospects, :cell_phone_2, :string

  end

  def down
  end
end
