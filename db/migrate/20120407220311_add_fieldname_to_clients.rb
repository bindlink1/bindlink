class AddFieldnameToClients < ActiveRecord::Migration
  def change
    add_column :clients, :agent_id, :integer
  end
end
