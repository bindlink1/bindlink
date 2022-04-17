class CreateWorksteps < ActiveRecord::Migration
  def change
    create_table :worksteps do |t|
      t.integer :workstream_id
      t.integer :workitem_id
      t.integer :agent_id
      t.integer :value
      t.timestamps
    end
  end
end
