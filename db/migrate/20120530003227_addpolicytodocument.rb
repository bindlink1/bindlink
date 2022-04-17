class Addpolicytodocument < ActiveRecord::Migration
  def up
    add_column :documents, :policy_id,:integer
    add_column :documents, :type,:string
  end

  def down
  end
end
