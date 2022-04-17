class Addgatotasks < ActiveRecord::Migration
  def up
    add_column :tasks, :generalagency_id, :integer
  end

  def down
  end
end
