class CreateChecklistitems < ActiveRecord::Migration
  def change
    create_table :checklistitems do |t|
      t.integer :checklist_id
      t.string :task_type
      t.string :item_name
      t.integer :agent_id
      t.timestamps
    end
  end
end
