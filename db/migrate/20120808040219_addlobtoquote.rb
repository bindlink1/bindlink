class Addlobtoquote < ActiveRecord::Migration
  def up
    add_column :quotes, :lineofbusiness_id, :integer
  end

  def down
  end
end
