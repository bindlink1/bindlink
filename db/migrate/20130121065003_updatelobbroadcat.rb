class Updatelobbroadcat < ActiveRecord::Migration
  def up
    rename_column :lineofbusinesses, :broad_category, :lobbroadcategory_id
  end

  def down
  end
end
