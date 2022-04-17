class CreateProspectpolicies < ActiveRecord::Migration
  def change
    create_table :prospectpolicies do |t|
      t.string :carrier
      t.date :expiration_date
      t.string :note
      t.timestamps
    end
  end
end
