class CreateSubmissionApplications < ActiveRecord::Migration
  def change
    create_table :submission_applications do |t|
      t.string :field_name
      t.string :response
      t.timestamps
    end
  end
end
