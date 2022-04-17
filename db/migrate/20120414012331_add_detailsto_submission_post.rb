class AddDetailstoSubmissionPost < ActiveRecord::Migration
  def up
    add_column :submissionposts, :submissionthread_id, :integer
    add_column :submissionposts, :submissionposttext, :text
    add_column :submissionposts, :agent_id, :integer
    add_column :submissionposts, :underwriter_id, :integer
  end

  def down
  end
end
