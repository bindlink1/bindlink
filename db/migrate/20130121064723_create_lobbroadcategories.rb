class CreateLobbroadcategories < ActiveRecord::Migration
  def change
    create_table :lobbroadcategories do |t|
      t.integer :agency_id
      t.integer :generalagency_id
      t.string :category_name
      t.timestamps
    end
  end
end
