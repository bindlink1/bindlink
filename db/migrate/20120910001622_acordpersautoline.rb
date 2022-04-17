class Acordpersautoline < ActiveRecord::Migration
  def up
    rename_column :acord_xml_pers_auto_line_businesses, :acordxmlpersautopolicy_id, :acord_xml_pers_auto_policy_id
  end

  def down
  end
end
