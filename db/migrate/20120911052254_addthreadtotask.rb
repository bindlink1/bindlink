class Addthreadtotask < ActiveRecord::Migration
  def up
    add_column :tasks, :mastertask_id, :integer
  end

  def down
  end
end
