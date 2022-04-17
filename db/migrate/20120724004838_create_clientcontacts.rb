class CreateClientcontacts < ActiveRecord::Migration
  def change
    create_table :clientcontacts do |t|
      t.integer :client_id
      t.string :contact_type
      t.string :contact_value
      t.string :note
      t.timestamps
    end
  end
end
