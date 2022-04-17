class CreateHoforms < ActiveRecord::Migration
  def change
    create_table :hoforms do |t|
      t.string :form_name
      t.timestamps
    end
  end
end
