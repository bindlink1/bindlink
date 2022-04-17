class Addquotetodocument < ActiveRecord::Migration
  def up
    add_column :documents, :quote_id, :integer
  end

  def down
  end
end
