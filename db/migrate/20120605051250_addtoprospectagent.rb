class Addtoprospectagent < ActiveRecord::Migration
  def up
    add_column :prospects, :agent_id,:integer
  end

  def down
  end
end
