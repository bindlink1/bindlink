class CreateAcordforminstances < ActiveRecord::Migration
  def change
    create_table :acordforminstances do |t|
      t.integer :acordform_id
      t.integer :agent_id
      t.integer :agency_id
      t.integer :generalagency_id
      t.integer :policy_id
      t.integer :client_id
      t.timestamps
    end
  end
end
