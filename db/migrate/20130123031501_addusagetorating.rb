class Addusagetorating < ActiveRecord::Migration
  def up
    add_column :homeownerpolicies, :usage, :string
  end

  def down
  end
end
