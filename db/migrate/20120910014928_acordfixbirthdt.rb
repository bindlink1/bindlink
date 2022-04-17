class Acordfixbirthdt < ActiveRecord::Migration
  def up
    rename_column :acord_xml_pers_drivers, :brith_date, :birth_dt
  end

  def down
  end
end
