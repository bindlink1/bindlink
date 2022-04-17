class CreateSubmissionApplicationResponses < ActiveRecord::Migration
  def change
    create_table :submission_application_responses do |t|

      t.timestamps
    end
  end
end
