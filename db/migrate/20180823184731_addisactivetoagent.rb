class Addisactivetoagent < ActiveRecord::Migration
  def change
    add_column :agents, :is_active, :boolean, :null => false, :default => true
  end
end
