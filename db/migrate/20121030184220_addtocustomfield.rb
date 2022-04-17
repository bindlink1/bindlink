class Addtocustomfield < ActiveRecord::Migration
  def up
    add_column :customfields, :associated_with, :string
  end

  def down
  end
end
