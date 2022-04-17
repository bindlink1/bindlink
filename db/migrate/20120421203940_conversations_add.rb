class ConversationsAdd < ActiveRecord::Migration
  def up
    add_column :conversations, :agency_id, :integer
    add_column :conversations, :agent_id, :integer
  end

  def down
  end
end
