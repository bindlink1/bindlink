class CreateBillingtypes < ActiveRecord::Migration
  def change
    create_table :billingtypes do |t|
      t.integer :billing_type_id
      t.string :billing_type_name
      t.timestamps
    end
  end
end
