class Addhashvalidtilltodocument < ActiveRecord::Migration
  def change
    add_column :documents, :hashvalidtill, :datetime
  end
end
