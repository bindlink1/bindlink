class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :policysearch
      t.integer :carrier_id

      t.timestamps
    end
  end
end
