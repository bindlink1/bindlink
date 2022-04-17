class CreateCustomfieldvalues < ActiveRecord::Migration
  def change
    create_table :customfieldvalues do |t|
      t.string :value
      t.date :value_date
      t.decimal :value_number
      t.integer :customfield_id
      t.integer :client_id
      t.integer :policy_id
      t.integer :producingagency_id
      t.timestamps
    end
  end
end
