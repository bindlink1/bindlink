class Producingagenciesaddfields < ActiveRecord::Migration
  def up
       add_column :producingagencies, :agency_name,:string
    add_column :producingagencies, :address_1,:string
     add_column :producingagencies, :address_2,:string
    add_column :producingagencies, :city,:string
    add_column :producingagencies, :state,:string
  add_column :producingagencies, :zip,:string
    add_column :producingagencies, :telephone,:string
  end

  def down
  end
end
