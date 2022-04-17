class Renameencryptedvalue < ActiveRecord::Migration
  def up
    rename_column :customfieldvalues, :encrypted_value, :encrypted_evalue
    rename_column :customfieldvalues, :encrypted_value_salt, :encrypted_evalue_salt
    rename_column :customfieldvalues, :encrypted_value_iv, :encrypted_evalue_iv
  end

  def down
  end
end
