class Addcompaytocashtrans < ActiveRecord::Migration
  def up
    add_column :cashtransactions, :compaybatchitem_id, :integer
  end

  def down
  end
end
