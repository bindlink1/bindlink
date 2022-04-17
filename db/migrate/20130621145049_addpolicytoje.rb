class Addpolicytoje < ActiveRecord::Migration
  def up
    add_column :journalentries, :policy_id, :integer
  end

  def down
  end
end
