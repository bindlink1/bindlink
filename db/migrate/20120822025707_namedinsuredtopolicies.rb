class Namedinsuredtopolicies < ActiveRecord::Migration
  def up
    add_column :policies, :namedinsured_id, :integer
    add_column :policies, :agency_comm_override, :decimal
    add_column :policies, :producingagency_comm_override, :decimal
  end

  def down
  end
end
