class Addprospectidtoclient < ActiveRecord::Migration
  def up
    add_column :clients, :prospect_id, :integer
  end

  def down
  end
end
