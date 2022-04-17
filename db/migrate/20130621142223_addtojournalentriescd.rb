class Addtojournalentriescd < ActiveRecord::Migration
  def up
    add_column :journalentries, :trans_type, :string
  end

  def down
  end
end
