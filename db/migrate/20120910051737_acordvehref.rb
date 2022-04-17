class Acordvehref < ActiveRecord::Migration
  def up
    rename_column :acord_xml_driver_vehs, :acordxmlperspolicy_id, :acord_xml_pers_policy_id
    rename_column :acord_xml_driver_vehs, :acordxmlpersdriver_id, :acord_xml_pers_driver_id
    rename_column :acord_xml_driver_vehs, :acordxmlpersveh_id, :acord_xml_pers_veh_id
  end

  def down
  end
end
