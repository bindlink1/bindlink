class CreateLobfees < ActiveRecord::Migration
  def change
    create_table :lobfees do |t|
      t.integer :lineofbusiness_id
      t.integer :fee_id
      t.timestamps
    end
  end
end
