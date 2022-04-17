class Addquotetopolicy < ActiveRecord::Migration
  def up
    add_column :policies, :quote_id, :integer
  end

  def down
  end
end
