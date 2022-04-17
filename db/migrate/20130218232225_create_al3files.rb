class CreateAl3files < ActiveRecord::Migration
  def change
    create_table :al3files do |t|
      t.integer :agency_id
      t.date :file_received_date
      t.string :file_name
      t.timestamps
    end
  end
end
