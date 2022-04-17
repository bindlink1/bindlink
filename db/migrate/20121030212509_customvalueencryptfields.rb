class Customvalueencryptfields < ActiveRecord::Migration
  def up
    add_column :customfieldvalues, :encrypted_value_salt, :string
    add_column :customfieldvalues, :encrypted_value_iv, :string
  end

  def down
  end
end
