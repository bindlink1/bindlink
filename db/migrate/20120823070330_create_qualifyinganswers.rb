class CreateQualifyinganswers < ActiveRecord::Migration
  def change
    create_table :qualifyinganswers do |t|
      t.integer :qualifyingquestion_id
      t.integer :onlinequote_id
      t.integer :answer
      t.timestamps
    end
  end
end
