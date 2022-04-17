class Addescriptionppt < ActiveRecord::Migration
  def up
    add_column :policypremiumtransactions, :description, :string
  end

  def down
  end
end
