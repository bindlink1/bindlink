class AcordXmlCoverage < ActiveRecord::Base
  belongs_to :acord_xml_pers_veh
  has_many :acord_xml_limits
  has_many :acord_xml_deductibles
  has_many :acord_xml_options

  accepts_nested_attributes_for :acord_xml_limits, :acord_xml_deductibles

  attr_accessible :coverage_cd
end
