class Create9bis < ActiveRecord::Migration
  def up
    add_column :al3h9bis, :header, :string
    add_column :al3h5bis, :street_address_line1, :string
    add_column :al3h5bis, :street_address_line2, :string
     add_column :al3h5bis, :city, :string
     add_column :al3h5bis, :state_abbreviation, :string
     add_column :al3h5bis, :zip_code, :string
     add_column :al3h5bis, :insureds_telephone_number, :string
     add_column :al3h5bis, :insureds_alternate_telephone_number, :string
     add_column :al3h5bis, :county_name, :string
     add_column :al3h5bis, :tax_code, :string
     add_column :al3h5bis, :country_name_code, :string
     add_column :al3h5bis, :insureds_telephone_number_type_code, :string
     add_column :al3h5bis, :address_line3, :string
     add_column :al3h5bis, :address_line4, :string
     add_column :al3h5bis, :insureds_alternate_telephone_number_type_code, :string
     add_column :al3h5bis, :insureds_telephone_number_extension, :string
     add_column :al3h5bis, :insureds_alternate_telephone_number_extension, :string
     add_column :al3h5bis, :coinsureds_telephone_number, :string
     add_column :al3h5bis, :coinsureds_alternate_telephone_number, :string
     add_column :al3h5bis, :coinsureds_telephone_number_extension, :string
     add_column :al3h5bis, :coinsureds_alternate_telephone_number_extension, :string
     add_column :al3h5bis, :insureds_alternate_telephone_number_2, :string
     add_column :al3h5bis, :insureds_alternate_telephone_number_2_type_code, :string
     add_column :al3h5bis, :insureds_alternate_telephone_number_2_extension, :string
     add_column :al3h5bis, :education_level_code, :string
     add_column :al3h5bis, :citizenship_country, :string
  end

  def down
  end
end
