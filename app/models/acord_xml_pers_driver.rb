class AcordXmlPersDriver < ActiveRecord::Base
  belongs_to :acord_xml_pers_auto_line_business
  has_many :acord_xml_driver_vehs, :dependent => :delete_all
  belongs_to :acord_xml_general_party_info

  attr_accessible :gender_cd, :birth_dt, :marital_status_cd, :license_status_cd, :license_dt, :driver_license_number, :state_prov_cd, :driver_type, :driver_relationship_to_applicant_cd, :mature_driver_ind, :driver_training_ind,:good_driver_ind, :good_student_cd

end
