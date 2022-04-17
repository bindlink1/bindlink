class AcordXmlPersPolicy < ActiveRecord::Base
  belongs_to :acord_xml_pers_auto_policy
  has_many :acord_xml_other_or_prior_policies, :dependent => :delete_all
  has_many :acord_xml_driver_vehs, :dependent => :delete_all
end
