class Addtocustomdocfields < ActiveRecord::Migration
  def up
	add_column :customdocumentfields, :attribute_name, :string
  end

  def down
  end
end
