class Adddetailstocarrierappoint < ActiveRecord::Migration
  def up
    add_column :carriers, :date_appointed,:date
  end

  def down
  end
end
