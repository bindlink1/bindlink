class Addtocustomfieldencrypt < ActiveRecord::Migration
  def up
    add_column :customfields, :encrypt, :boolean
  end

  def down
  end
end
