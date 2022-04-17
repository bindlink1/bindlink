class Addsubmissiontodocs < ActiveRecord::Migration
  def up
    add_column :documents, :submission_id, :integer
  end

  def down
  end
end
