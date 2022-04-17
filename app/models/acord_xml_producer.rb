class AcordXmlProducer < ActiveRecord::Base
  belongs_to :acord_xml_pers_auto_policy
  has_one :acord_xml_general_party_info, :dependent => :destroy
end
