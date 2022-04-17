class Addtosubmission < ActiveRecord::Migration
  def up
    add_column :submissions, :generalagency_id, :integer
     add_column :submissions, :agent_id, :integer
     add_column :submissions, :location_id, :integer
  end

  def down
  end
end
