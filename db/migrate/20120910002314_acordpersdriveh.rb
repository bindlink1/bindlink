class Acordpersdriveh < ActiveRecord::Migration
  def up
    rename_column :acord_xml_pers_drivers, :acordxmlpersautolinebusiness_id,:acord_xml_pers_auto_line_business_id
    add_column :acord_xml_pers_drivers, :acord_xml_general_party_info_id, :integer
    rename_column :acord_xml_pers_vehs, :acordxmlpersautolinebusiness_id,:acord_xml_pers_auto_line_business_id


  end

  def down
  end
end
