class CreateGllosscosts < ActiveRecord::Migration
  def change
    create_table :gllosscosts do |t|
      t.integer :class_code
      t.string :state
      t.decimal :premops
      t.decimal :prodcops
      t.timestamps
    end
  end
end
