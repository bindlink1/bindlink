class CreateQuotingentities < ActiveRecord::Migration
  def change
    create_table :quotingentities do |t|
      t.string :quotingentity_name
      t.string :address_1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :telephone
      t.string :principal
      t.date :signed_up
      t.string :license_number
      t.boolean :approved
      t.date :approved_on

      t.timestamps
    end
  end
end
