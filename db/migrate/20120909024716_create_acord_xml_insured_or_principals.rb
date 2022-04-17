class CreateAcordXmlInsuredOrPrincipals < ActiveRecord::Migration
  def change
    create_table :acord_xml_insured_or_principals do |t|
      t.integer :acordxmlpersautopolicy_id
      t.string :insured_or_principal_role_cd
      t.string :gender_cd
      t.date :birth_dt
      t.string :marital_status_cd
      t.string :occupation_class_cd
      t.string :length_time_with_previous_employer
      t.string :relationship_cd
      t.timestamps
    end
  end
end
