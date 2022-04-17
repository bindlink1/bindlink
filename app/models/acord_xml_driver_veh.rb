class AcordXmlDriverVeh < ActiveRecord::Base
  belongs_to :acord_xml_pers_policy
  has_one :acord_xml_pers_driver, :dependent => :destroy
  has_one :acord_xml_pers_veh, :dependent => :destroy
end
