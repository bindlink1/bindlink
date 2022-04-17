class Addremindertotask < ActiveRecord::Migration
  def up
    add_column :tasks, :reminder_date, :date
    add_column :tasks, :submission_id, :integer
  end

  def down
  end
end
