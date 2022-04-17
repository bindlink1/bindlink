class AddEnabledToLobcommissions < ActiveRecord::Migration
  def change
    add_column :lobcommissions, :enabled, :boolean, :null => false, :default => true
  end
end
