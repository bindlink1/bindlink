class CreateZipcounties < ActiveRecord::Migration
  def change
    create_table :zipcounties do |t|
      t.string :zip
      t.string :county_name
      t.timestamps
    end
  end
end
