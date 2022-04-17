class Adderrortotempdocs < ActiveRecord::Migration
  def up
    add_column :tempdocs, :upload_error, :string
  end

  def down
  end
end
