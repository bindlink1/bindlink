class Addhoautotolob < ActiveRecord::Migration
  def up
    add_column :lineofbusinesses, :broad_category, :string
  end

  def down
  end
end
