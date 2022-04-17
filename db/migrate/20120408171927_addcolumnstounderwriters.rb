class Addcolumnstounderwriters < ActiveRecord::Migration
  def up
    add_column :underwriters, :quotingentity_id, :integer
  end

  def down
    remove_column :underwriters, :agency_name, :string
  end
end
