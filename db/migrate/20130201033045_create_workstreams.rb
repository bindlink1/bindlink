class CreateWorkstreams < ActiveRecord::Migration
  def change
    create_table :workstreams do |t|
      t.integer :agency_id
      t.integer :generalagency_id
      t.string :workstream_name
      t.timestamps
    end
  end
end
