class Agencytolocation < ActiveRecord::Migration
  def up
    add_column :locations, :agency_id, :integer
    add_column :locations, :generalagency_id, :integer
  end

  def down
  end
end
