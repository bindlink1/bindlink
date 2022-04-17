class CreateCustomdocuments < ActiveRecord::Migration
  def change
    create_table :customdocuments do |t|
	t.integer :agency_id
	t.integer :generalagency_id
	t.string :document_name
	t.string :file_name
	t.string :document_model
      t.timestamps
    end
  end
end
