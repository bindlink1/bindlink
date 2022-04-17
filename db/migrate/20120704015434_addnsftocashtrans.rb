class Addnsftocashtrans < ActiveRecord::Migration
  def up
    add_column :cashtransactions, :agency_id, :integer
    add_column :cashtransactions, :generalagency_id, :integer
    add_column :cashtransactions, :nsf_flag, :string
    add_column :cashtransactions, :transfer_flag, :string
    add_column :cashtransactions, :reversed_flag, :string
  end

  def down
  end
end
