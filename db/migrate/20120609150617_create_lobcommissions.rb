class CreateLobcommissions < ActiveRecord::Migration
  def change
    create_table :lobcommissions do |t|
      t.integer :carrierlob_id
      t.string :state
      t.decimal :commission_rate
      t.timestamps
    end
  end
end
