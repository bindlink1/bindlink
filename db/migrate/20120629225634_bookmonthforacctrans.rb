class Bookmonthforacctrans < ActiveRecord::Migration
  def up
    add_column :accountingtransactions, :book_month, :integer
    add_column :accountingtransactions, :book_year, :integer
  end

  def down
  end
end
