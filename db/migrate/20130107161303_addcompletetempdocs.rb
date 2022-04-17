class Addcompletetempdocs < ActiveRecord::Migration
  def up
    add_column :tempdocs, :upload_status, :string
  end

  def down
  end
end
