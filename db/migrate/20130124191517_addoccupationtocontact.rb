class Addoccupationtocontact < ActiveRecord::Migration
  def up
    add_column :clientcontacts, :occupation, :string
  end

  def down
  end
end
