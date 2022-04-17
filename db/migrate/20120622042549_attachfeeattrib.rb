class Attachfeeattrib < ActiveRecord::Migration
  def up
    add_column :fees, :attach_type, :string
  end

  def down
  end
end
