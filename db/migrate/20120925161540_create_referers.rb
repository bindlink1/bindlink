class CreateReferers < ActiveRecord::Migration
  def change
    create_table :referers do |t|
      t.integer :client_id
      t.string :referer_name
      t.string :email
      t.timestamps
    end
  end
end
