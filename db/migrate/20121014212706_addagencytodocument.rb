class Addagencytodocument < ActiveRecord::Migration
  def up
    add_column :documents, :generalagency_id, :integer
    add_column :documents, :agency_id, :integer
  end

  def down
  end
end
