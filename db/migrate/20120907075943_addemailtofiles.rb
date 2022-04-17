class Addemailtofiles < ActiveRecord::Migration
  def up
    add_column :inboundemails, :generalagency_id, :integer
    add_column :inboundemails, :policy_id, :integer
    add_column :inboundemails, :client_id, :integer
    add_column :inboundemails, :submission_id, :integer
    add_column :inboundemails, :read_flag, :integer
  end

  def down
  end
end
