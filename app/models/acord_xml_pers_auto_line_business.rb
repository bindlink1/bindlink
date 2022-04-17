class AcordXmlPersAutoLineBusiness < ActiveRecord::Base
  belongs_to :acord_xml_pers_auto_policy
  has_many :acord_xml_pers_drivers, :dependent => :delete_all
  has_many :acord_xml_pers_vehs, :dependent => :delete_all
  accepts_nested_attributes_for :acord_xml_pers_auto_policy
  attr_accessible :acord_xml_pers_drivers
end
