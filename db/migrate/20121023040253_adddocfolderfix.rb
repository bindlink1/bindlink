class Adddocfolderfix < ActiveRecord::Migration
  def up
    remove_column :agents, :docfolder
    add_column :agencies, :docfolder, :string
  end

  def down
  end
end
