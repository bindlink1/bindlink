class CreateClientphoneemails < ActiveRecord::Migration
  def change
    create_table :clientphoneemails do |t|
      t.integer :client_id
      t.string :contact_type
      t.string :contact_value
      t.string :note
      t.integer :clientcontact_id
      t.timestamps
    end
  end
end
