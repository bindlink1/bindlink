class Create5drv < ActiveRecord::Migration
  def up
    add_column :al3h5drvs, :header, :string
    add_column :al3h5drvs, :al3h5bpi_id, :integer
     add_column :al3h5drvs, :drivers_name, :string
    add_column :al3h5drvs, :date_of_birth, :date
    add_column :al3h5drvs, :driver_sex_code, :string
    add_column :al3h5drvs, :licensed_state, :string
    add_column :al3h5drvs, :social_security_number, :string
    add_column :al3h5drvs, :drivers_license_number, :string
    add_column :al3h5drvs, :driver_type_code, :string
  end

  def down
  end
end
