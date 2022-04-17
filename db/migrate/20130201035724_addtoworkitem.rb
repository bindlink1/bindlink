class Addtoworkitem < ActiveRecord::Migration
  def up
    add_column :workitems, :workitem_name, :string
  end

  def down
  end
end
