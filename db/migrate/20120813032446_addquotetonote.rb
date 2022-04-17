class Addquotetonote < ActiveRecord::Migration
  def up
    add_column :notes, :quote_id, :integer
  end

  def down
  end
end
