class Completedbynote < ActiveRecord::Migration
  def up
    add_column :tasks, :completed_by, :integer
  end

  def down
  end
end
