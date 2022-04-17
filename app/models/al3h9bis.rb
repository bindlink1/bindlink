class Al3h9bis < ActiveRecord::Base
  belongs_to :al3h2trg
  def process(algroup, trgid)
    al9bis = Al3h9bis.new
    al9bis.al3h2trg_id = trgid
    al9bis.header = algroup[0..29]
    al9bis.street_address_line1 = algroup[30..59]
    al9bis.street_address_line2 = algroup[60..89]
    al9bis.city = algroup[90..108]
    al9bis.state_abbreviation = algroup[109..110]
    al9bis.zip_code = algroup[111..119]
    al9bis.insureds_telephone_number = algroup[120..133]
    al9bis.insureds_alternate_telephone_number = algroup[134..147]
    al9bis.county_name = algroup[148..166]
    al9bis.tax_code = algroup[167..172]
    al9bis.country_name_code = algroup[173..175]
    al9bis.insureds_telephone_number_type_code = algroup[176..176]
    al9bis.address_line3 = algroup[177..206]
    al9bis.address_line4 = algroup[207..236]
    al9bis.insureds_alternate_telephone_number_type_code = algroup[237..237]
    al9bis.insureds_telephone_number_extension = algroup[238..247]
    al9bis.insureds_alternate_telephone_number_extension = algroup[248..257]
    al9bis.coinsureds_telephone_number = algroup[258..271]
    al9bis.coinsureds_alternate_telephone_number = algroup[272..285]
    #al9bis.coinsureds_telephone_number_type_Code
    #al9bis.coinsureds_alternate_telephone_number_type_Code
    al9bis.coinsureds_telephone_number_extension = algroup[288..297]
    al9bis.coinsureds_alternate_telephone_number_extension = algroup[298..307]
    al9bis.insureds_alternate_telephone_number_2 = algroup[308..321]
    al9bis.insureds_alternate_telephone_number_2_type_code = algroup[322..322]
    al9bis.insureds_alternate_telephone_number_2_extension = algroup[323..332]
     al9bis.education_level_code = algroup[335..339]
    al9bis.citizenship_country = algroup[340..342]
    al9bis.save

  end
end
