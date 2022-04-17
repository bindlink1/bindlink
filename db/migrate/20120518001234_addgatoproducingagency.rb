class Addgatoproducingagency < ActiveRecord::Migration
  def up
    add_column :producingagencies, :generalagency_id ,:integer
  end

  def down
  end
end
