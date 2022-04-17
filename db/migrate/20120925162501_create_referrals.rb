class CreateReferrals < ActiveRecord::Migration
  def change
    create_table :referrals do |t|
      t.integer :client_id
      t.integer :referer_id
      t.timestamps
    end
  end
end
