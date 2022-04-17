class Addfieldstoprospect < ActiveRecord::Migration
  def up
    add_column :prospects, :address_1, :string
    add_column :prospects, :address_2, :string
    add_column :prospects, :city, :string
    add_column :prospects, :state, :string
    add_column :prospects, :zip, :string
    add_column :prospects, :comments, :text
    add_column :prospects, :mailing_address_1, :string
    add_column :prospects, :mailing_address_2, :string
    add_column :prospects, :mailing_city, :string
    add_column :prospects, :mailing_state, :string
    add_column :prospects, :mailing_zip, :string
    add_column :prospects, :location_id, :integer
    add_column :clients, :location_id, :integer
    add_column :policies, :location_id, :integer
  end

  def down
  end
end
