class Correctreportingcolumn < ActiveRecord::Migration
  def up
    rename_column :reportingwarehouses, :yearrmo, :yearmo
    rename_column :reportingwarehouses, :edorsement_count, :endorsement_count

  end

  def down
  end
end
