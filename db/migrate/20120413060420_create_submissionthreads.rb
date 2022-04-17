class CreateSubmissionthreads < ActiveRecord::Migration
  def change
    create_table :submissionthreads do |t|

      t.timestamps
    end
  end
end
