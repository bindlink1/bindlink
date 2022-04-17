class Addquotetotasks < ActiveRecord::Migration
  def up
    add_column :tasks, :quote_id, :integer
  end

  def down
  end
end
