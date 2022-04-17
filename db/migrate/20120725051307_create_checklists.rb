class CreateChecklists < ActiveRecord::Migration
  def change
    create_table :checklists do |t|
      t.integer :policy_id
      t.integer :lobcommission_id
      t.integer :agent_id
      t.string :task_name
      t.string :task_type
      t.date :completed_on
      t.timestamps
    end
  end
end
