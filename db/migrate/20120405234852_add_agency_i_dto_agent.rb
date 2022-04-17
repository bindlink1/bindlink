class AddAgencyIDtoAgent < ActiveRecord::Migration
  def change
    add_column :agents, :agency_id, :integer
  end

end
