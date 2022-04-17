class CreateReturnpremiumbatchpreitems < ActiveRecord::Migration
  def change
    create_table :returnpremiumbatchpreitems do |t|
      t.integer :return_premium_batch_id
      t.integer :policy_id
      t.timestamps
    end
  end
end
