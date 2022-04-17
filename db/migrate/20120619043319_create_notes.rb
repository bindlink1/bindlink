class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
        t.integer :policy_id
        t.integer :client_id
        t.text :notetext
        t.integer :agent_id
        t.integer :agency_id
        t.integer :prospect_id
        t.timestamps
    end
  end
end
