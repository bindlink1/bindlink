class Addtoaccttransactions < ActiveRecord::Migration
  def up
    add_column :accountingtransactions, :cashtransaction_id, :integer
  end

  def down
  end
end
