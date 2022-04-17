class AcordXmlDeductible < ActiveRecord::Base
  belongs_to :acord_xml_coverage

  attr_accessible :deductible_type_cd, :deductible_applies_to_cd, :deductible_amt

end
