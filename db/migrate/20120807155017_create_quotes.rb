class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.integer :agent_id
      t.integer :agency_id
      t.integer :generalagency_id
      t.integer :submission_id
      t.integer :client_id
      t.integer :carrier_id
      t.integer :lobcommission_id
      t.string :quotedescription
      t.integer :base_premium
      t.integer :total_fees
      t.integer :total_premium
      t.timestamps
    end
  end
end
