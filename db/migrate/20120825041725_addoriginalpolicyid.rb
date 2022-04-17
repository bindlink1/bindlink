class Addoriginalpolicyid < ActiveRecord::Migration
  def up
    add_column :policies, :originalpolicy_id, :integer
  end

  def down
  end
end
