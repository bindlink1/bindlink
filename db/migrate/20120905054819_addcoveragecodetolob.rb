class Addcoveragecodetolob < ActiveRecord::Migration
  def up
    add_column :lineofbusinesses, :coverage_code, :integer
  end

  def down
  end
end
