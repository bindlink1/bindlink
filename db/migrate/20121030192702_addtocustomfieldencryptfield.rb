class Addtocustomfieldencryptfield < ActiveRecord::Migration
  def up
    add_column :customfieldvalues, :encrypted_value, :string
  end

  def down
  end
end
