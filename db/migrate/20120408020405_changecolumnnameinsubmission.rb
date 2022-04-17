class Changecolumnnameinsubmission < ActiveRecord::Migration
  def up
    rename_column :submissions, :agent_id, :agency_id
  end

  def down
  end
end
