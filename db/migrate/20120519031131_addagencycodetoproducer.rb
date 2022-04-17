class Addagencycodetoproducer < ActiveRecord::Migration
  def up
     add_column :producingagencies, :agency_code ,:string
     add_column :producingagencies, :agency_contact ,:string
    add_column :producingagencies, :tax_id ,:string
    add_column :producingagencies, :telephone_2 ,:string
     add_column :producingagencies, :mailing_address_1,:string
    add_column :producingagencies, :mailing_address_2,:string
    add_column :producingagencies, :mailing_city,:string
    add_column :producingagencies, :mailing_state,:string
    add_column :producingagencies, :mailing_zip,:string
    add_column :producingagencies, :main_email,:string
  end

  def down
  end
end
