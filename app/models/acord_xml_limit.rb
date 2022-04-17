class AcordXmlLimit < ActiveRecord::Base
  belongs_to :acord_xml_coverage

  attr_accessible :limit_amt, :limit_applies_to_cd


end
