class AddAuthorityToAgent < ActiveRecord::Migration
  def up
    add_column :agents, :is_admin, :boolean


  end

  def down
  end
end
