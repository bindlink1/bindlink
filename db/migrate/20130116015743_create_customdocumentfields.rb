class CreateCustomdocumentfields < ActiveRecord::Migration
  def change
    create_table :customdocumentfields do |t|
	t.integer :customdocument_id
	t.string :field_name
	t.string :field_model
	t.integer :location_x
	t.integer :location_y
	t.integer :font_size
      t.timestamps
    end
  end
end
