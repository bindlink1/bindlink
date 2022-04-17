class Renamepptaccountingtrans < ActiveRecord::Migration
  def up
    rename_column :accountingtransactions, :policypremiumtransactions_id, :policypremiumtransaction_id
  end

  def down
  end
end
