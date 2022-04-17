class Agencyforacctrans < ActiveRecord::Migration
  def up
    add_column :accountingtransactions, :agency_id, :integer
    add_column :accountingtransactions, :generalagency_id, :integer
  end

  def down
  end
end
