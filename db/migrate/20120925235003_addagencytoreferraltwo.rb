class Addagencytoreferraltwo < ActiveRecord::Migration
  def up
        add_column :referrals, :agency_id, :integer
    add_column :referers, :agency_id, :integer
  end

  def down
  end
end
