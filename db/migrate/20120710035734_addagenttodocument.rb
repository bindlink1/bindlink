class Addagenttodocument < ActiveRecord::Migration
  def up
    add_column :documents, :agent_id, :integer
  end

  def down
  end
end
