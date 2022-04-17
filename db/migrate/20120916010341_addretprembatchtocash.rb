class Addretprembatchtocash < ActiveRecord::Migration
  def up
    add_column :cashtransactions, :return_premium_batch_id, :integer
  end

  def down
  end
end
