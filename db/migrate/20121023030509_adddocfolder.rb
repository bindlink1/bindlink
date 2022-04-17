class Adddocfolder < ActiveRecord::Migration
  def up
    add_column :agents, :docfolder, :string
    add_column :generalagencies, :docfolder, :string
  end

  def down
  end
end
