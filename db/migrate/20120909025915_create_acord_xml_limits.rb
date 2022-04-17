class CreateAcordXmlLimits < ActiveRecord::Migration
  def change
    create_table :acord_xml_limits do |t|
      t.integer :acordxmlcoverage_id
      t.integer :limit_amt
      t.string :limit_applies_to_cd
      t.timestamps
    end
  end
end
