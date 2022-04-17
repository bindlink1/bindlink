class AddFieldsToAdmins < ActiveRecord::Migration
  def change
       add_column :admins, :first_name, :string
      add_column :admins, :last_name, :string
      add_column :admins, :agency_name, :string
  end
end
