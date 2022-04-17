class CreateCarrierlobs < ActiveRecord::Migration
  def change
    create_table :carrierlobs do |t|
      t.integer :carrier_id
      t.integer :lineofbusiness_id
      t.timestamps
    end
  end
end
