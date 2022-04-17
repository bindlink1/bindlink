class Fixdatatypelobpol < ActiveRecord::Migration
  def up
    change_column :policies, :lineofbusiness_id, :string
  end

  def down
  end
end
