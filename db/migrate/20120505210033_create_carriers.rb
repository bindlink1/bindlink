class CreateCarriers < ActiveRecord::Migration
  def change
    create_table :carriers do |t|
      t.string :carrier_name
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zip
      t.decimal :commission_percent
      t.string :billing_type
      t.integer :agency_id
      t.timestamps
    end
  end
end
