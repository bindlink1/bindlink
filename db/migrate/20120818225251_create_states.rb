class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :full_name
      t.string :abbreviation
      t.string :region
      t.string :regulatory_type
      t.timestamps
    end
  end
end
