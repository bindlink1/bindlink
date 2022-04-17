class CreateNamedinsureds < ActiveRecord::Migration
  def change
    create_table :namedinsureds do |t|
      t.integer :generalagency_id
      t.integer :producingagency_id
      t.string :named_insured
      t.timestamps
    end
  end
end
