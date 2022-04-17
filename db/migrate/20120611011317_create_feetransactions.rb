class CreateFeetransactions < ActiveRecord::Migration
  def change
    create_table :feetransactions do |t|
      t.integer :lobfee_id
      t.integer :policypremiumtransaction_id
      t.integer :policy_id
      t.decimal :fee_amount
      t.timestamps
    end
  end
end
