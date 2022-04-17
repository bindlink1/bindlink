class Effexpfees < ActiveRecord::Migration
  def up
    add_column :fees, :effective_date, :date
    add_column :fees, :expiration_date, :date
  end

  def down
  end
end
