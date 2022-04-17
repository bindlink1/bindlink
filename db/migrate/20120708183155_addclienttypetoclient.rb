class Addclienttypetoclient < ActiveRecord::Migration
  def up
    add_column :clients, :client_type, :string
    add_column :clients, :first_name, :string
    add_column :clients, :last_name, :string
    add_column :clients, :corporate_name, :string
  end

  def down
  end
end
