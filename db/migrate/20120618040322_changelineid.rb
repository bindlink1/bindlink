class Changelineid < ActiveRecord::Migration
  def up
     rename_column :policies, :line_id, :lineofbusiness_id
  end

  def down
  end
end
