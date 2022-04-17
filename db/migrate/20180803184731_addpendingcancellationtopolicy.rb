class Addpendingcancellationtopolicy < ActiveRecord::Migration
  def change
    add_column :policies, :is_pendingcancellation, :boolean
    add_column :policies, :pendingcancellation_set_date, :datetime
  end
end
