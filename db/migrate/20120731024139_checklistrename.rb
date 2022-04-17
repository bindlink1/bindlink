class Checklistrename < ActiveRecord::Migration
def change
  change_table :checklists do |t|

         t.rename :task_name, :checklist_name
        t.remove :policy_id, :task_type, :completed_on

  end
end
end
