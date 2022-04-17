class Checklistagencylink < ActiveRecord::Migration
  def up
    add_column :checklists, :agency_id, :integer
    add_column :checklists, :generalagency_id, :integer
  end

  def down
  end
end
