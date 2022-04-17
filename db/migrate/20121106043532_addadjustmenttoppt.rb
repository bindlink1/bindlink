class Addadjustmenttoppt < ActiveRecord::Migration
  def up
    add_column :policypremiumtransactions, :adjustment_to, :integer
  end

  def down
  end
end
