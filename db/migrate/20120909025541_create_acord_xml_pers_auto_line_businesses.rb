class CreateAcordXmlPersAutoLineBusinesses < ActiveRecord::Migration
  def change
    create_table :acord_xml_pers_auto_line_businesses do |t|
      t.integer :acordxmlpersautopolicy_id
      t.timestamps
    end
  end
end
