class Acordpersvehidcode < ActiveRecord::Migration
  def up
    rename_column :acord_xml_pers_vehs, :veh_idenfication_number, :veh_identification_number
  end

  def down
  end
end
