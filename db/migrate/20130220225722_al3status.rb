class Al3status < ActiveRecord::Migration
  def up
    add_column :al3files, :processed, :boolean
    add_column :al3transactions, :processed, :boolean
  end

  def down
  end
end
