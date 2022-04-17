class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :policy_id
      t.integer :client_id
      t.string :task_name
      t.string :task_type
      t.integer :agent_id
      t.integer :agency_id
      t.date :completed_on
      t.string :status
      t.timestamps
    end
  end
end
