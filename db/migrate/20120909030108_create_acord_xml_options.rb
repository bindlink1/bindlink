class CreateAcordXmlOptions < ActiveRecord::Migration
  def change
    create_table :acord_xml_options do |t|
      t.integer :acordxmlcoverage_id
      t.string :option_cd
      t.timestamps
    end
  end
end
