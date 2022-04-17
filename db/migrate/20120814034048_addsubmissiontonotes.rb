class Addsubmissiontonotes < ActiveRecord::Migration
  def up
    add_column :notes, :submission_id, :integer
  end

  def down
  end
end
