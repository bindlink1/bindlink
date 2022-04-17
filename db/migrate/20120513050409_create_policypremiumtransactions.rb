class CreatePolicypremiumtransactions < ActiveRecord::Migration
  def change
    create_table :policypremiumtransactions do |t|
      t.decimal :base_premium
      t.decimal :taxes
      t.decimal :fees
      t.decimal :total_premium
      t.timestamps
    end
  end
end
