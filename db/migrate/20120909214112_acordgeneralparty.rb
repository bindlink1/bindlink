class Acordgeneralparty < ActiveRecord::Migration
  def up
    rename_column :acord_xml_general_party_infos, :acordxmlproducer_id ,:acord_xml_producer_id
    rename_column :acord_xml_general_party_infos, :acordxmlinsuredorprincipal_id ,:acord_xml_insured_or_principal_id
  end

  def down
  end
end
