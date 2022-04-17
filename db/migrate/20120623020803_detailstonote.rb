class Detailstonote < ActiveRecord::Migration
  def up
    add_column :notes, :generalagency_id, :integer
  end

  def down
  end
end
