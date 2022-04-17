class CreateClientaddresses < ActiveRecord::Migration
  def change
    create_table :clientaddresses do |t|
      t.integer :client_id
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zip
      t.string :address_type
      t.string :note
      t.integer :clientcontact_id
      t.timestamps
    end
  end
end
