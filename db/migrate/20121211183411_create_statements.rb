class CreateStatements < ActiveRecord::Migration
  def change
    create_table :statements do |t|
      t.integer :carrier_id
      t.integer :agency_id
      t.integer :generalagency_id
      t.date :start_date
      t.date :end_date
      t.integer :agent_id
      t.decimal :statement_total
      t.timestamps
    end
  end
end
