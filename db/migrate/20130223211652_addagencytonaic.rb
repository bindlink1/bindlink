class Addagencytonaic < ActiveRecord::Migration
  def up
    add_column :carriernaics, :agency_id, :integer

  end

  def down
  end
end
