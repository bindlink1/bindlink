class Create5lag < ActiveRecord::Migration
  def up
    add_column :al3h5lags, :header, :string
    add_column :al3h5lags, :al3h5bpi_id, :integer
    add_column :al3h5lags, :location_number, :integer
    add_column :al3h5lags, :street_address_line1, :string
    add_column :al3h5lags, :street_address_line2, :string
    add_column :al3h5lags, :city, :string
    add_column :al3h5lags, :state_abbreviation, :string
    add_column :al3h5lags, :zip_code, :string
    add_column :al3h5lags, :county_name, :string
  end

  def down
  end
end
