class Addrefflagclient < ActiveRecord::Migration
  def up
    add_column :clients, :referer_id, :integer
  end

  def down
  end
end
