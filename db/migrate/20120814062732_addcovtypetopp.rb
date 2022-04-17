class Addcovtypetopp < ActiveRecord::Migration
  def up
    add_column :prospectpolicies, :coverage_type, :string
  end

  def down
  end
end
