class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :policy_id
      t.date :created_on
      t.date :due_on
      t.timestamps
    end
  end
end
