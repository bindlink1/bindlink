class Checklistitemsrename < ActiveRecord::Migration
def change
  change_table :checklistitems do |t|

        t.rename :item_name, :task_name


  end
end
end
