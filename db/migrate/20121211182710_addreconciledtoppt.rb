class Addreconciledtoppt < ActiveRecord::Migration
  def up
    add_column :policypremiumtransactions, :reconciled, :string
    add_column :policypremiumtransactions, :reconciled_date, :date
    add_column :policypremiumtransactions, :statement_id, :integer
  end

  def down
  end
end
