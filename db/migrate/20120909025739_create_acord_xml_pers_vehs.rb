class CreateAcordXmlPersVehs < ActiveRecord::Migration
  def change
    create_table :acord_xml_pers_vehs do |t|
      t.integer :acordxmlpersautolinebusiness_id
      t.string :model_year
      t.string :manufacturer
      t.string :model
      t.string :veh_idenfication_number
      t.string :anti_lock_brake_cd
      t.string :anti_theft_device_cd
      t.integer :present_value_amt
      t.integer :cost_new_amt
      t.integer :distance_one_way
      t.integer :estimated_annual_distance
      t.string :ownership
      t.string :carpool_ind
      t.integer :num_days_driver_per_week
      t.integer :length_time_per_month
      t.string :air_bag_type_cd
      t.string :veh_performance_cd
      t.string :veh_use_cd
      t.string :existing_unrepaired_damage_ind
      t.timestamps
    end
  end
end
