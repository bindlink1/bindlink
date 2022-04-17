class Acordfixpersvehs < ActiveRecord::Migration
  def up

    add_column :acord_xml_pers_vehs, :daytime_running_light_ind, :string

  end

  def down
  end
end
