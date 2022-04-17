class Pfcupdate < ActiveRecord::Migration
  def up
    add_column :pfcs, :zip,:string
  end

  def down
  end
end
