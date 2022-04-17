class Addentryitemstostatement < ActiveRecord::Migration
  def up
    add_column :statementitems, :itemamount, :decimal
    add_column :statementitems, :itemprocessedflag, :string
  end

  def down
  end
end
