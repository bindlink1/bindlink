class CreateAcordfieldvalues < ActiveRecord::Migration
  def change
    create_table :acordfieldvalues do |t|
      t.integer :acordform_id
      t.integer :acordformfield_id
      t.integer :acordforminstance_id
      t.string :fielddata
      t.integer :agent_id
      t.timestamps
    end
  end
end
