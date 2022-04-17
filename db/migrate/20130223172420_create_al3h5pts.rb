class CreateAl3h5pts < ActiveRecord::Migration

  def change
    create_table :al3h5pts do |t|
      t.integer :al3h2trg_id
      t.integer :line_number
      t.text :line_content
      t.timestamps
    end
  end
end
