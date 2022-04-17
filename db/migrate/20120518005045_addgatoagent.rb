class Addgatoagent < ActiveRecord::Migration
  def up
    add_column :agents, :generalagency_id ,:integer
  end

  def down
  end
end
