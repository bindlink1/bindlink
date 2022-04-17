class Acordxmlcovfix < ActiveRecord::Migration
  def up
    rename_column :acord_xml_coverages, :acordxmlpersveh_id, :acord_xml_pers_veh_id
    rename_column :acord_xml_limits, :acordxmlcoverage_id, :acord_xml_coverage_id
    rename_column :acord_xml_options, :acordxmlcoverage_id, :acord_xml_coverage_id
    rename_column :acord_xml_deductibles, :acordxmlcoverage_id, :acord_xml_coverage_id
  end

  def down
  end
end
