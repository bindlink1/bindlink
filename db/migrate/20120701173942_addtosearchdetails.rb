class Addtosearchdetails < ActiveRecord::Migration
  def up
    add_column :searches, :agency_id, :integer
    add_column :searches, :generalagency_id, :integer
    add_column :searches, :agent_id, :integer
  end

  def down
  end
end
