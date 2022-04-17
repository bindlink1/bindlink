class CreatePfcs < ActiveRecord::Migration
  def change
    create_table :pfcs do |t|
    t.string :pfc_name
    t.string :address
    t.string :address_2
    t.string :city
    t.string :state
    t.string :date
    t.string :telephone
    t.string :agency_code
    t.string :marketing_contact
    t.string :marketing_telephone
    t.string :marketing_email
    t.string :contact
    t.string :contact_telephone
    t.string:contact_email
    t.integer :agency_id
    t.integer :generalagency_id
      t.timestamps
    end
  end
end
