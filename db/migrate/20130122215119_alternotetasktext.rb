class Alternotetasktext < ActiveRecord::Migration
  def up
    change_column :tasks, :task_name, :text
    change_column :notes, :notetext, :text
  end

  def down
  end
end
