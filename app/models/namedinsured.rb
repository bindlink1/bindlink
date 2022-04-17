class Namedinsured < ActiveRecord::Base
  belongs_to :generalagency
  belongs_to :producingagency
  has_many :submissions
  has_many :policies
  attr_accessible :named_insured, :address_1, :address_2, :city, :state, :zip

  def county

    zipcode = self.zip[0,5]


    county = Zipcounty.where('zip=?',zipcode)

   begin
  county.first.county_name
   rescue
        "Dade"
     end

  end

  def fixzip
     zipcode = self.zip[0,5]

     zipcode

  end

  def valid
    if zip != "" and state != "" and address_1 != "" and city != "" then
      true
    else
      false
    end
  end

end
