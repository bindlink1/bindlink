class CreateLineofbusinesses < ActiveRecord::Migration
  def change
    create_table :lineofbusinesses do |t|
      t.integer :agency_id
      t.integer :generalagency_id
      t.string :line_name
      t.timestamps
    end
  end
end
