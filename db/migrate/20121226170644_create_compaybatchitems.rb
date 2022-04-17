class CreateCompaybatchitems < ActiveRecord::Migration
  def change
    create_table :compaybatchitems do |t|
      t.integer :policy_id
      t.integer :compay_batch_id
      t.integer :cashtransaction_id
      t.integer :producingagency_id
      t.timestamps
    end
  end
end
