class Addtorepeatingfields < ActiveRecord::Migration
  def up
    add_column :customdocumentfieldrepeats, :customdocument_id, :integer
    add_column :customdocumentfieldrepeats, :field_model, :string
    add_column :customdocumentfieldrepeats, :field_name, :string
    add_column :customdocumentfieldrepeats, :title_name, :string
    add_column :customdocumentfieldrepeats, :title_model, :string
  end

  def down
  end
end
