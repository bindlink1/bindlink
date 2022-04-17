class CreateAcordXmlCoverages < ActiveRecord::Migration
  def change
    create_table :acord_xml_coverages do |t|
      t.integer :acordxmlpersveh_id
      t.string :coverage_cd
      t.timestamps
    end
  end
end
