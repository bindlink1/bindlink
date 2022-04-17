class Addagencytoal3trans < ActiveRecord::Migration
  def up
    add_column :al3transactions, :agency_id, :integer
  end

  def down
  end
end
