class Addtojournalentries < ActiveRecord::Migration
  def up
    add_column :journalentries, :assetaccount_id, :integer
    add_column :journalentries, :liabilityaccount_id, :integer
    add_column :journalentries, :amount, :decimal
  end

  def down
  end
end
