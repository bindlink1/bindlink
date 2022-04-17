class Acordlocation < ActiveRecord::Migration
  def up
    rename_column :acord_xml_locations, :acordxmlpersautopolicy_id, :acord_xml_pers_auto_policy_id
  end

  def down
  end
end
