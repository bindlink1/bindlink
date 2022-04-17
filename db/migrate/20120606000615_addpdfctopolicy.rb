class Addpdfctopolicy < ActiveRecord::Migration
  def up
    add_column :policies, :pfc_date_due,:date
     add_column :policies, :pfc_id,:integer
     add_column :policies, :pfc_contract,:string
  end

  def down
  end
end
