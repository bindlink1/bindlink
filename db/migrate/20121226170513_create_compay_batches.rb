class CreateCompayBatches < ActiveRecord::Migration
  def change
    create_table :compay_batches do |t|
      t.integer :generalagency_id
      t.decimal :batch_total
      t.integer :transaction_count
      t.integer :check_start
      t.integer :check_end
      t.integer :agent_id
      t.string :status
      t.timestamps
    end
  end
end
