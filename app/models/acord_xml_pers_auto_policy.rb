class AcordXmlPersAutoPolicy < ActiveRecord::Base
  belongs_to :policy
  has_one :acord_xml_producer, :dependent => :destroy
  has_many :acord_xml_insured_or_principals, :dependent => :delete_all
  has_one :acord_xml_pers_policy, :dependent => :destroy
  has_one :acord_xml_pers_auto_line_business, :dependent => :destroy
  has_many :acord_xml_locations, :dependent => :delete_all


  accepts_nested_attributes_for :acord_xml_pers_auto_line_business
  attr_accessible :acord_xml_pers_auto_line_business_attributes, :acord_xml_insured_or_principals, :acord_xml_locations, :acord_xml_pers_vehs, :acord_xml_general_party_info, :acord_xml_pers_drivers
end
