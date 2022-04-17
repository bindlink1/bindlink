class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.integer :agent_id
      t.string :client_id
      t.string :from
      t.string :to
      t.string :subject
      t.text :body
      t.timestamps
    end
  end
end
