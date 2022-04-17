class Addpagenumbertoaccordform < ActiveRecord::Migration
  def up
    add_column :acordforms, :numberofpages, :integer
  end

  def down
  end
end
