class Addfeetofeetransactions < ActiveRecord::Migration
  def up
    add_column :feetransactions, :fee_id, :integer
  end

  def down
  end
end
