class Addidstonamedinsured < ActiveRecord::Migration
  def up
    add_column :namedinsureds, :submission_id, :integer
    add_column :namedinsureds, :policy_id, :integer
  end

  def down
  end
end
