class Addtojournalentriesfix < ActiveRecord::Migration
  def up
    remove_column :journalentries, :assetaccount_id
    remove_column :journalentries, :liabilityaccount_id
    add_column :journalentries, :accountingaccount_id, :integer
  end

  def down
  end
end
