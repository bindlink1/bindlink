class Addgeneralagentfields < ActiveRecord::Migration
  def up
    add_column :policies, :generalagency_id ,:integer
  end

  def down
  end
end
