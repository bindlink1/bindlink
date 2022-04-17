class Completepages < ActiveRecord::Migration
  def up
    add_column :documentpages, :image_file_name, :string
     add_column :documentpages, :image_content_type , :string
    add_column :documentpages, :image_file_size , :integer
  end

  def down
  end
end
