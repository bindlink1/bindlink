class CreateAcordXmlLocations < ActiveRecord::Migration
  def change
    create_table :acord_xml_locations do |t|
      t.integer :acordxmlpersautopolicy_id
      t.string :addr_type_cd
      t.string :addr_1
      t.string :city
      t.string :county
      t.string :state_prov_cd
      t.string :postal_code
      t.timestamps
    end
  end
end
