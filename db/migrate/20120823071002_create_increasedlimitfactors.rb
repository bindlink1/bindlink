class CreateIncreasedlimitfactors < ActiveRecord::Migration
  def change
    create_table :increasedlimitfactors do |t|
      t.integer :class_code
      t.string :state
      t.integer :aggregate
      t.integer :per_occurence
      t.decimal :increased_factor
      t.string :table_name
      t.timestamps
    end
  end
end
