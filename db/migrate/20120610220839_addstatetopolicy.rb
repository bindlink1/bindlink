class Addstatetopolicy < ActiveRecord::Migration
  def up

    add_column :policies, :state,:string

  end

  def down
  end
end
