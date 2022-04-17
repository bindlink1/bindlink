class Addbookdatetoppt < ActiveRecord::Migration
  def up
    add_column :policypremiumtransactions, :book_date, :date
  end

  def down
  end
end
