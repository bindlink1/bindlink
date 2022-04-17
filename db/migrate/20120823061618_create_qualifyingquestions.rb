class CreateQualifyingquestions < ActiveRecord::Migration
  def change
    create_table :qualifyingquestions do |t|
      t.integer :class_code
      t.string :question
      t.string :required_answer
      t.integer :carrier_id
      t.timestamps
    end
  end
end
