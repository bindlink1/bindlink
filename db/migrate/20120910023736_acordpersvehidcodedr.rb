class Acordpersvehidcodedr < ActiveRecord::Migration
  def up
    rename_column :acord_xml_pers_vehs, :num_days_driver_per_week ,:num_days_driven_per_week
  end

  def down
  end
end
