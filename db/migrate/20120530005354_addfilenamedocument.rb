class Addfilenamedocument < ActiveRecord::Migration
  def up
    add_column :documents, :name,:string
  end

  def down
  end
end
