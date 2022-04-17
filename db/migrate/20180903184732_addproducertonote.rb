class Addproducertonote < ActiveRecord::Migration
  def change
    add_column :notes, :producingagency_id, :integer
  end
end
