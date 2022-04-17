class Addeffectivedatetoppt < ActiveRecord::Migration
  def up
    add_column :policypremiumtransactions, :transaction_effective_date, :date
  end

  def down
  end
end
