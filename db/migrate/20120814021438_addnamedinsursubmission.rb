class Addnamedinsursubmission < ActiveRecord::Migration
  def up
    add_column :submissions, :namedinsured_id, :integer
  end

  def down
  end
end
