class CreateReturnpremiumbatchitems < ActiveRecord::Migration
  def change
    create_table :returnpremiumbatchitems do |t|
      t.integer :policy_id
      t.integer :return_premium_batch_id
      t.timestamps
    end
  end
end
