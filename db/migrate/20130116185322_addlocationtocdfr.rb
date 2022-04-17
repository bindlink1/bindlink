class Addlocationtocdfr < ActiveRecord::Migration
  def up
    add_column :customdocumentfieldrepeats, :location_x, :integer
    add_column :customdocumentfieldrepeats, :location_y, :integer
    add_column :customdocumentfieldrepeats, :field_type, :string
  end

  def down
  end
end
