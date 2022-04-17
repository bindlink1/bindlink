class CreateAcordformfields < ActiveRecord::Migration
  def change
    create_table :acordformfields do |t|
      t.integer :acordform_id
      t.string :formfieldname
      t.integer :width
      t.integer :height
      t.integer :xpos
      t.integer :ypos
      t.text :help
      t.string :prevformfieldname
      t.string :nextformfieldname
      t.string :fieldtype
      t.timestamps
    end
  end
end
