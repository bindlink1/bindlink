class CreateAcordXmlDeductibles < ActiveRecord::Migration
  def change
    create_table :acord_xml_deductibles do |t|
      t.integer :acordxmlcoverage_id
      t.string :deductible_type_cd
      t.string :deductible_applies_to_cd
      t.integer :deductible_amt
      t.timestamps
    end
  end
end
