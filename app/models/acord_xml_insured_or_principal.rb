class AcordXmlInsuredOrPrincipal < ActiveRecord::Base
  belongs_to :acord_xml_pers_auto_policy
  has_one :acord_xml_general_party_info, :dependent => :destroy

  accepts_nested_attributes_for :acord_xml_general_party_info

  attr_accessible  :gender_cd, :birth_dt, :marital_status_cd, :relationship_cd
end
