class Editstatementgrouptocarriers < ActiveRecord::Migration
  def up
    remove_column :carriers, :isstatementgroup
    add_column :carriers, :isstatementgroup, :boolean
  end

  def down
  end
end
