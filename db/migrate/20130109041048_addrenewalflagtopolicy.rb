class Addrenewalflagtopolicy < ActiveRecord::Migration
  def up
    add_column :policies, :is_renewal, :boolean
  end

  def down
  end
end
