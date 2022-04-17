class Addadjustflagppt < ActiveRecord::Migration
  def up
   add_column :policypremiumtransactions, :adjusted, :string
  end

  def down
  end
end
