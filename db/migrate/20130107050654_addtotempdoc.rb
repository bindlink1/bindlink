class Addtotempdoc < ActiveRecord::Migration
  def up
    add_column :tempdocs, :policy_id, :integer
    add_column :tempdocs, :quote_id, :integer
    add_column :tempdocs, :s3_path, :string
    add_column :tempdocs, :file_name, :string
  end

  def down
  end
end
