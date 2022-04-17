class CreateAcordXmlDriverVehs < ActiveRecord::Migration
  def change
    create_table :acord_xml_driver_vehs do |t|
      t.integer :acordxmlperspolicy_id
      t.integer :acordxmlpersdriver_id
      t.integer :acordxmlpersveh_id
      t.integer :use_pct
      t.timestamps
    end
  end
end
