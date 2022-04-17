class Addmorefieldstoproducer < ActiveRecord::Migration
  def up
     add_column :producingagencies, :address_3,:string
    add_column :producingagencies, :address_4,:string
    add_column :producingagencies, :name1099,:string
    add_column :producingagencies, :address1099,:string
    add_column :producingagencies, :city1099,:string
    add_column :producingagencies, :state1099,:string
    add_column :producingagencies, :zip1099,:string

  end

  def down
  end
end
