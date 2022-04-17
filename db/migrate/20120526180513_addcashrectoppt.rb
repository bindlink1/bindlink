class Addcashrectoppt < ActiveRecord::Migration
  def up
    add_column :policypremiumtransactions, :cash_received, :string
  end

  def down
  end
end
