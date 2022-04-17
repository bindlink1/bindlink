class Adduserstocash < ActiveRecord::Migration
  def up
    add_column :cashtransactions, :agent_id, :integer
  end

  def down
  end
end
