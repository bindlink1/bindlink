class Addmainlocationflag < ActiveRecord::Migration
  def up
    add_column :locations, :main_location_flag, :boolean
  end

  def down
  end
end
