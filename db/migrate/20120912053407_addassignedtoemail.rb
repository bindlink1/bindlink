class Addassignedtoemail < ActiveRecord::Migration
  def up
    add_column :inboundemails, :assigned_flag, :integer
  end

  def down
  end
end
