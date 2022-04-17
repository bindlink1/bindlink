class CreateAgencies < ActiveRecord::Migration
  def change
    create_table :agencies do |t|
      t.string :agency_name
      t.string :address_1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :telephone
      t.string :principal
      t.string :license_number
      t.boolean :approved
      t.date :approved_on

      t.timestamps
    end
  end
end
