class CreateJournalentries < ActiveRecord::Migration
  def change
    create_table :journalentries do |t|

      t.timestamps
    end
  end
end
