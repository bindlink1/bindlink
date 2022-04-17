class Addagencytolobcommissions < ActiveRecord::Migration
  def up
     add_column :lobcommissions, :agency_id,:integer
     add_column :lobcommissions, :generalagency_id,:integer
  end

  def down
  end
end
