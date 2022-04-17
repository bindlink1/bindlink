class Addclienttodocument < ActiveRecord::Migration
  def up
    add_column :documents, :client_id, :integer
    add_column :documents, :producingagency_id, :integer
  end

  def down
  end
end
