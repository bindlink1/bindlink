class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :client_name
      t.string :address_1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :telephone
      t.text :comments

      t.timestamps
    end
  end
end
