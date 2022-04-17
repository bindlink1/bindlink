class Addstatementgrouptocarriers < ActiveRecord::Migration
  def up
    add_column :carriers, :statementgroup_id, :integer
    add_column :carriers, :isstatementgroup, :string
  end

  def down
  end
end
