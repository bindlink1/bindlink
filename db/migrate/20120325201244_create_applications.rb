class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.string :named_insured
      t.integer :premium
      t.date :bound

      t.timestamps
    end
  end
end
