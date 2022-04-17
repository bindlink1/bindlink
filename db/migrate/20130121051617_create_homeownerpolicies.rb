class CreateHomeownerpolicies < ActiveRecord::Migration
  def change
    create_table :homeownerpolicies do |t|
      t.integer :policy_id
      t.decimal :dwelling_coverage
      t.decimal :otherstructure_coverage
      t.decimal :lossofuse_coverage
      t.decimal :contents_coverage
      t.decimal :additionalliving_coverage
      t.decimal :liability_coverage
      t.decimal :medpay_coverage
      t.string :construction_type
      t.integer :year_built
      t.integer :sq_footage
      t.integer :number_rooms
      t.integer :roof_age
      t.boolean :alarm
      t.boolean :swimming_pool
      t.boolean :fire_station
      t.boolean :replacement_cost
      t.timestamps
    end
  end
end
