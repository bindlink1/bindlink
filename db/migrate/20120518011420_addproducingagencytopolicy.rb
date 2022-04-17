class Addproducingagencytopolicy < ActiveRecord::Migration
  def up
    add_column :policies, :producingagency_id ,:integer
  end

  def down
  end
end
