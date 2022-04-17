class Addbatchtocash < ActiveRecord::Migration
  def up
    add_column :cashtransactions, :returnpremiumbatchitem_id, :integer
  end

  def down
  end
end
