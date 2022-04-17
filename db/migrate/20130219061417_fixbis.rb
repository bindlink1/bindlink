class Fixbis < ActiveRecord::Migration
  def up

    remove_column :al3h5bis, :street_address_line1
    remove_column :al3h5bis, :street_address_line2
    remove_column :al3h5bis, :city
    remove_column :al3h5bis, :state_abbreviation
    remove_column :al3h5bis, :zip_code
    remove_column :al3h5bis, :insureds_telephone_number
    remove_column :al3h5bis, :insureds_alternate_telephone_number
    remove_column :al3h5bis, :county_name
    remove_column :al3h5bis, :tax_code
    remove_column :al3h5bis, :country_name_code
    remove_column :al3h5bis, :insureds_telephone_number_type_code
    remove_column :al3h5bis, :address_line3
    remove_column :al3h5bis, :address_line4
    remove_column :al3h5bis, :insureds_alternate_telephone_number_type_code
    remove_column :al3h5bis, :insureds_telephone_number_extension
    remove_column :al3h5bis, :insureds_alternate_telephone_number_extension
    remove_column :al3h5bis, :coinsureds_telephone_number
    remove_column :al3h5bis, :coinsureds_alternate_telephone_number
    remove_column :al3h5bis, :coinsureds_telephone_number_extension
    remove_column :al3h5bis, :coinsureds_alternate_telephone_number_extension
    remove_column :al3h5bis, :insureds_alternate_telephone_number_2
    remove_column :al3h5bis, :insureds_alternate_telephone_number_2_type_code
    remove_column :al3h5bis, :insureds_alternate_telephone_number_2_extension
    remove_column :al3h5bis, :education_level_code
    remove_column :al3h5bis, :citizenship_country

    add_column :al3h5bis, :al3h2trg_id, :string
    add_column :al3h9bis, :al3h2trg_id, :string
    add_column :al3h9bis, :street_address_line1, :string
    add_column :al3h9bis, :street_address_line2, :string
    add_column :al3h9bis, :city, :string
    add_column :al3h9bis, :state_abbreviation, :string
    add_column :al3h9bis, :zip_code, :string
    add_column :al3h9bis, :insureds_telephone_number, :string
    add_column :al3h9bis, :insureds_alternate_telephone_number, :string
    add_column :al3h9bis, :county_name, :string
    add_column :al3h9bis, :tax_code, :string
    add_column :al3h9bis, :country_name_code, :string
    add_column :al3h9bis, :insureds_telephone_number_type_code, :string
    add_column :al3h9bis, :address_line3, :string
    add_column :al3h9bis, :address_line4, :string
    add_column :al3h9bis, :insureds_alternate_telephone_number_type_code, :string
    add_column :al3h9bis, :insureds_telephone_number_extension, :string
    add_column :al3h9bis, :insureds_alternate_telephone_number_extension, :string
    add_column :al3h9bis, :coinsureds_telephone_number, :string
    add_column :al3h9bis, :coinsureds_alternate_telephone_number, :string
    add_column :al3h9bis, :coinsureds_telephone_number_extension, :string
    add_column :al3h9bis, :coinsureds_alternate_telephone_number_extension, :string
    add_column :al3h9bis, :insureds_alternate_telephone_number_2, :string
    add_column :al3h9bis, :insureds_alternate_telephone_number_2_type_code, :string
    add_column :al3h9bis, :insureds_alternate_telephone_number_2_extension, :string
    add_column :al3h9bis, :education_level_code, :string
    add_column :al3h9bis, :citizenship_country, :string
  end

  def down
  end
end
