class CreateCompaybatchpreitems < ActiveRecord::Migration
  def change
    create_table :compaybatchpreitems do |t|
      t.integer :policy_id
      t.integer :compay_batch_id
      t.timestamps
    end
  end
end
