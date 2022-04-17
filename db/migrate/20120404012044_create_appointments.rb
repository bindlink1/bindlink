class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.integer :agency_id
      t.integer :quotingentity_id
      t.date :active_on
      t.date :exipiration_on

      t.timestamps
    end
  end
end
