class Addtocontacts < ActiveRecord::Migration
  def up
    add_column :clientcontacts, :encrypted_ssn,:string
    add_column :clientcontacts, :encrypted_ssn_salt,:string
    add_column :clientcontacts, :encrypted_ssn_iv,:string
    add_column :clientcontacts, :encrypted_dlnum,:string
    add_column :clientcontacts, :encrypted_dlnum_salt,:string
    add_column :clientcontacts, :encrypted_dlnum_iv,:string
    add_column :clientcontacts, :dlstate,:string
    add_column :clientcontacts, :dlexp,:date
    add_column :clientcontacts, :birth_date,:date
    add_column :clientcontacts, :sex, :string

  end

  def down
  end
end
