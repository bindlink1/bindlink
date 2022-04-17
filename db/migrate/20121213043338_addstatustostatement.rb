class Addstatustostatement < ActiveRecord::Migration
  def up
    add_column :statements, :status, :string
  end

  def down
  end
end
