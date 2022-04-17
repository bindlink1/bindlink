class CreateAcordXmlPersPolicies < ActiveRecord::Migration
  def change
    create_table :acord_xml_pers_policies do |t|
      t.integer :acordxmlpersautopolicy_id
      t.string :lob_cd
      t.string :billing_method_cd
      t.date :effective_dt
      t.string :residence_type_cd
      t.integer :length_years
      t.integer :length_months

      t.timestamps
    end
  end
end
