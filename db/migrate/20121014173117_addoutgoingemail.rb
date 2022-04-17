class Addoutgoingemail < ActiveRecord::Migration
  def up
    add_column :agents, :outboundemail, :string
  end

  def down
  end
end
