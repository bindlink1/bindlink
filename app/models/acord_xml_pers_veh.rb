class AcordXmlPersVeh < ActiveRecord::Base
  belongs_to :acord_xml_pers_auto_line_business
  has_many :acord_xml_coverages, :dependent => :delete_all
  has_many :acord_xml_driver_vehs, :dependent => :delete_all
  has_one :acord_xml_location, :dependent => :destroy

  accepts_nested_attributes_for :acord_xml_coverages

  attr_accessible  :model_year, :manufacturer, :model, :veh_identification_number, :anti_lock_brake_cd, :anti_theft_device_cd, :present_value_amt, :cost_new_amt, :estimated_annual_distance, :ownership, :air_bag_type_cd, :anti_lock_brake_cd,  :veh_use_cd
end
