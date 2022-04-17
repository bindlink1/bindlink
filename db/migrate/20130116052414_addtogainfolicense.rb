class Addtogainfolicense < ActiveRecord::Migration
  def up
	add_column :generalagencies, :surpluslines_agent_name, :string
	add_column :generalagencies, :surpluslines_agent_license, :string
  end

  def down
  end
end
