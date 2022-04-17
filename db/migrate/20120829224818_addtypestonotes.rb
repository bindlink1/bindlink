class Addtypestonotes < ActiveRecord::Migration
  def up
    add_column :notes, :note_type, :string
  end

  def down
  end
end
