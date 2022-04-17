class AcordXmlGeneralPartyInfo < ActiveRecord::Base
  belongs_to :acord_xml_producer
  belongs_to :acord_xml_insured_or_principal
  has_one :acord_xml_pers_driver

  accepts_nested_attributes_for :acord_xml_pers_driver

  attr_accessible :given_name, :surname, :tax_id_type_cd, :tax_id, :acord_xml_pers_driver
end
