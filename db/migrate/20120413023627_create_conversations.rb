class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.integer :submission_id
      t.integer :underwriter_id
      t.integer :quotingentity_id
      t.timestamps
    end
  end
end
