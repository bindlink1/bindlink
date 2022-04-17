class CreateAcordXmlPersDrivers < ActiveRecord::Migration
  def change
    create_table :acord_xml_pers_drivers do |t|
      t.integer :acordxmlpersautolinebusiness_id
      t.string :gender_cd
      t.date :brith_date
      t.string :marital_status_cd
      t.string :occupation_class_cd
      t.string :license_status_cd
      t.date :license_dt
      t.string :driver_license_number
      t.string :state_prov_cd
      t.string :veh_principally_driven_ref
      t.string :resident_custody_ind
      t.string :driver_type
      t.string :driver_relationship_to_applicant_cd
      t.string :mature_driver_ind
      t.string :driver_training_ind
      t.string :good_student_cd
      t.string :good_driver_ind
      t.string :distant_student_ind
      t.string :filing_status_cd
      t.string :license_suspended_revoked_ind
      t.timestamps
    end
  end
end
