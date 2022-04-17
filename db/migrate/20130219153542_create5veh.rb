class Create5veh < ActiveRecord::Migration
  def up
      add_column :al3h5vehs, :header, :string
    add_column :al3h5vehs, :al3h5lag_id, :integer
    add_column :al3h5vehs,:company_vehicle_number,  :integer
    add_column :al3h5vehs,:agency_vehicle_number,  :integer
    add_column :al3h5vehs,:vehicle_year,  :integer
    add_column :al3h5vehs,:vehicle_make,  :string
    add_column :al3h5vehs,:vehicle_model,  :string
    add_column :al3h5vehs,:vin,  :string
    add_column :al3h5vehs,:vehicle_registration_state,  :string
    add_column :al3h5vehs,:cost_new,  :integer

  end

  def down
  end
end
