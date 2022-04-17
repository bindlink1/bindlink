class AddDetailstoSubmissionThread < ActiveRecord::Migration
  def up
    add_column :submissionthreads, :conversation_id, :integer
  end

  def down
  end
end
