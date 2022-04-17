class Adddocumentidtopages < ActiveRecord::Migration
  def up
    add_column :documentpages, :document_id, :integer
  end

  def down
  end
end
