class Generalagenciesaddfields < ActiveRecord::Migration
  def up
    add_column :generalagencies, :agency_name,:string
    add_column :generalagencies, :address_1,:string
     add_column :generalagencies, :address_2,:string
    add_column :generalagencies, :city,:string
    add_column :generalagencies, :state,:string
  add_column :generalagencies, :zip,:string
    add_column :generalagencies, :telephone,:string
  end

  def down
  end
end
