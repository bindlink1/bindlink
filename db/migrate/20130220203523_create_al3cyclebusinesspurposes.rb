class CreateAl3cyclebusinesspurposes < ActiveRecord::Migration
  def change
    create_table :al3cyclebusinesspurposes do |t|
      t.string :code_value
      t.string :code_description
      t.timestamps
    end
  end
end
