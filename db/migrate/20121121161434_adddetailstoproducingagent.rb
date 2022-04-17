class Adddetailstoproducingagent < ActiveRecord::Migration
  def up
    add_column :producingagencies, :agency_fax, :string
    add_column :producingagencies, :main_agent_license, :string
  end

  def down
  end
end
