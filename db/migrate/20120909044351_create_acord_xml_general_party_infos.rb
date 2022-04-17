class CreateAcordXmlGeneralPartyInfos < ActiveRecord::Migration
  def change
    create_table :acord_xml_general_party_infos do |t|
      t.integer :acordxmlproducer_id
      t.integer :acordxmlinsuredorprincipal_id
      t.string :surname
      t.string :given_name
      t.string :tax_id_type_cd
      t.string :tax_id
      t.string :addr_type_cd
      t.string :addr_1
      t.string :addr_2
      t.string :city
      t.string :county
      t.string :state_prov_cd
      t.string :postal_code
      t.string :phone_type_cd
      t.string :communication_use_cd
      t.string :phone_number
      t.timestamps
    end
  end
end
