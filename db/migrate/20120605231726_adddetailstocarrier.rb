class Adddetailstocarrier < ActiveRecord::Migration
  def up
    add_column :carriers, :email,:string
    add_column :carriers, :marketing_contact,:string
    add_column :carriers, :marketing_telephone,:string
    add_column :carriers, :marketing_email,:string
    add_column :carriers, :underwriting_contact,:string
    add_column :carriers, :underwriting_telephone,:string
    add_column :carriers, :underwriting_email,:string
    add_column :carriers, :agency_code,:string
  end

  def down
  end
end
