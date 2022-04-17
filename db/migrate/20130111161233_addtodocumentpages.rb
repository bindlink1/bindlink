class Addtodocumentpages < ActiveRecord::Migration
  def up
    add_column :documentpages, :agency_id, :integer
    add_column :documentpages, :generalagency_id, :integer
    add_column :documentpages, :page_number, :integer
  end

  def down
  end
end
