class Addproducingagencytoclients < ActiveRecord::Migration
  def up
    add_column :clients, :producingagency_id ,:integer
    add_column :clients, :generalagency_id ,:integer
  end

  def down
  end
end
