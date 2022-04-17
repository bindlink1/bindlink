class Addstatustoclient < ActiveRecord::Migration
  def up
    add_column :clients, :client_status, :string
  end

  def down
  end
end
