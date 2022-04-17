class CreateStatementitems < ActiveRecord::Migration
  def change
    create_table :statementitems do |t|
      t.integer :statement_id
      t.integer :policypremiumtransaction_id
      t.timestamps
    end
  end
end
