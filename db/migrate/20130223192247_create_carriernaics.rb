class CreateCarriernaics < ActiveRecord::Migration
  def change
    create_table :carriernaics do |t|
      t.integer :carrier_id
      t.string :naic_number
      t.timestamps
    end
  end
end
