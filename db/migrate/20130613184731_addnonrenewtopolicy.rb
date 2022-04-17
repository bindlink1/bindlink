class Addnonrenewtopolicy < ActiveRecord::Migration
  def up
    add_column :policies, :is_nonrenew, :boolean
  end

  def down
  end
end
