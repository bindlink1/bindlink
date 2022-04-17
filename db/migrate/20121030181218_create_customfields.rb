class CreateCustomfields < ActiveRecord::Migration
  def change
    create_table :customfields do |t|
      t.integer :agency_id
      t.integer :producingagency_id
      t.string :field_name
      t.string :field_type
      t.timestamps
    end
  end
end
