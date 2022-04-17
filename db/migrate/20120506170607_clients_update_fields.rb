class ClientsUpdateFields < ActiveRecord::Migration
  def up
    add_column :clients, :agency_id, :integer
  end

  def down
  end
end
