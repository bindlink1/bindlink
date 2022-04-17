class Addmailingaddresstoclient < ActiveRecord::Migration
  def up
    add_column :clients, :mailing_address_1,:string
    add_column :clients, :mailing_address_2,:string
    add_column :clients, :mailing_city,:string
    add_column :clients, :mailing_state,:string
    add_column :clients, :mailing_zip,:string
    add_column :clients, :email,:string
  end

  def down
  end
end
