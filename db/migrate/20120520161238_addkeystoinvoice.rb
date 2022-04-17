class Addkeystoinvoice < ActiveRecord::Migration
  def up
    add_column :invoices, :agency_id ,:integer
    add_column :invoices, :generalagency_id ,:integer
    add_column :invoices, :producingagency_id ,:integer
  end

  def down
  end
end
