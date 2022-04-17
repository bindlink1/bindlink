class Addtocustomdocumentfields < ActiveRecord::Migration
  def up
	add_column :customdocumentfields, :field_type, :string
  end

  def down
  end
end
