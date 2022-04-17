class Addppttoaccountingtransactions < ActiveRecord::Migration
  def up
     add_column :accountingtransactions, :policypremiumtransactions_id ,:integer
  end

  def down
  end
end
