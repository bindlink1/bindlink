class CreateSubmissionposts < ActiveRecord::Migration
  def change
    create_table :submissionposts do |t|

      t.timestamps
    end
  end
end
