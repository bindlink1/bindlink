class AddFieldsToUnderwriter < ActiveRecord::Migration
  def change
     add_column :underwriters, :first_name, :string
      add_column :underwriters, :last_name, :string
      add_column :underwriters, :agency_name, :string
  end
end
