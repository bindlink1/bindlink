class Changepolicyterm < ActiveRecord::Migration
  def up
    change_column :policies, :policy_term, :string
  end

  def down
  end
end
