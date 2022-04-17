class AcordXmlLocation < ActiveRecord::Base
  belongs_to :acord_xml_pers_auto_policy
  has_many :acord_xml_pers_vehs, :dependent => :delete_all

  attr_accessible :addr_type_cd, :addr_1, :city, :county, :state_prov_cd, :postal_code
end
