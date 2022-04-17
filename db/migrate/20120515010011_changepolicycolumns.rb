class Changepolicycolumns < ActiveRecord::Migration
  def up

    change_column :policies, :coverage_id, :string
  end

  def down
  end
end
