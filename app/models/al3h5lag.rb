class Al3h5lag < ActiveRecord::Base
  belongs_to :al3h5bpi
  has_many :al3h5vehs
   has_many :al3h6cvas

  def process(algroup, bpiid)
    al5lag = Al3h5lag.new
    al5lag.al3h5bpi_id = bpiid
    al5lag.header = algroup[0..29]
    al5lag.location_number = algroup[30..33]
    al5lag.street_address_line1 = algroup[34..63]
    al5lag.street_address_line2 = algroup[64..93]
    al5lag.city = algroup[94..112]
    al5lag.state_abbreviation = algroup[113..114]
    al5lag.zip_code = algroup[115..123]
    al5lag.county_name = algroup[124..142]
    al5lag.save

    al5lag.id
  end

  def autocoverages
    ac = Al3h6cva.new
    fac = ac.autocoverages(self.id)
    fac
  end
end
