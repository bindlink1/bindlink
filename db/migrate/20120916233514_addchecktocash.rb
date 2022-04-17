class Addchecktocash < ActiveRecord::Migration
  def up
    add_column :cashtransactions, :check_number, :string
    add_column :cashtransactions, :producingagency_id , :integer
    add_column :cashtransactions, :client_id, :integer
    add_column :cashtransactions, :carrier_id, :integer
    add_column :cashtransactions, :pfc_id, :integer

  end

  def down
  end
end
