class Al3h5veh < ActiveRecord::Base
  belongs_to :al3h5lag
  has_many :al3h6cvas

  def process(algroup, lagid)
    al5veh = Al3h5veh.new
    al5veh.al3h5lag_id = lagid
    al5veh.header = algroup[0..29]
    al5veh.company_vehicle_number = algroup[30..33]
    al5veh.agency_vehicle_number = algroup[34..37]
    al5veh.vehicle_year = algroup[38..41]
    al5veh.vehicle_make = algroup[42..61]
    al5veh.vehicle_model = algroup[62..81]
    al5veh.vin = algroup[87..111]
    al5veh.vehicle_registration_state = algroup[112..113]
    al5veh.cost_new = algroup[118..125]
    al5veh.save

    al5veh.id
  end
end
