class CreateFslsodata < ActiveRecord::Migration
  def change
    create_table :fslsodata do |t|
      t.string :policy_number
      t.string :insured_name
      t.string :county
      t.string :postal_code
      t.date :effective_date
      t.date :expiration_date
      t.date :issue_date
      t.integer :coverage_code
      t.integer :transaction_type
      t.string :insurer_name
      t.string :naic_number
      t.decimal :premium
      t.decimal :policy_fee
      t.timestamps
    end
  end
end
