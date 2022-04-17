class Al3h5drv < ActiveRecord::Base
  belongs_to :al3h5bpi

  def process(algroup, bpiid)
    al5drv = Al3h5drv.new
    al5drv.al3h5bpi_id = bpiid
    al5drv.header = algroup[0..29]
    al5drv.drivers_name = algroup[38..97]
    al5drv.date_of_birth = algroup[160..167]
    al5drv.driver_sex_code = algroup[146..146]
    al5drv.licensed_state = algroup[132..133]
    al5drv.social_security_number = algroup[98..106]
    al5drv.drivers_license_number = algroup[107..131]
    al5drv.driver_type_code = algroup[154..154]
    al5drv.save
  end
end
