class Addclientstoprospectpol < ActiveRecord::Migration
  def up
    add_column :prospectpolicies, :client_id, :integer
  end

  def down
  end
end
