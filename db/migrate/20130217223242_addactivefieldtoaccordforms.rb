class Addactivefieldtoaccordforms < ActiveRecord::Migration
  def up
    add_column :acordforms, :active, :boolean
  end

  def down
  end
end
