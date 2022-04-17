class CreatePolicies < ActiveRecord::Migration
  def change
    create_table :policies do |t|
      t.integer :agency_id
      t.integer :client_id
      t.integer :carrier_id
      t.integer :mga_id
      t.text :policy_type
      t.date :effective_date
      t.integer :policy_term
      t.timestamps
    end
  end
end
