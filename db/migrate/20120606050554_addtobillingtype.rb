class Addtobillingtype < ActiveRecord::Migration
  def up
     add_column :billingtypes, :group,:string
  end

  def down
  end
end
