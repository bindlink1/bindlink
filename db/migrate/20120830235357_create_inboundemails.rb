class CreateInboundemails < ActiveRecord::Migration
  def change
    create_table :inboundemails do |t|
      t.integer :agency_id
      t.string :sender
      t.string :from
      t.string :subject
      t.text :stripped_text
      t.timestamps
    end
  end
end
