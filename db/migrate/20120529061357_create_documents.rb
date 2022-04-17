class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.date :image_updated_at
      t.string :notes
      t.timestamps
    end
  end
end
