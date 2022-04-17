class Addcashtobatchitems < ActiveRecord::Migration
  def up
    add_column :returnpremiumbatchitems, :cashtransaction_id, :integer
  end

  def down
  end
end
