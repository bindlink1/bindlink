class Addcomplexfeestoppt < ActiveRecord::Migration
  def up
    add_column :policypremiumtransactions, :complexfees, :decimal
  end

  def down
  end
end
