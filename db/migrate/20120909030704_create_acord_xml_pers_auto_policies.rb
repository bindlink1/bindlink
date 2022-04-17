class CreateAcordXmlPersAutoPolicies < ActiveRecord::Migration
  def change
    create_table :acord_xml_pers_auto_policies do |t|
      t.integer :policy_id
      t.timestamps
    end
  end
end
