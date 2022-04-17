class CreateFees < ActiveRecord::Migration
  def change
    create_table :fees do |t|
        t.integer :agency_id
        t.integer :generalagency_id
        t.string :fee_name
        t.string :fee_type
        t.integer :lineofbusiness_id
        t.string :state
        t.decimal :fee_value
        t.timestamps
    end
  end
end
