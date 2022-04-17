class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.integer :client_id
      t.date :created_on

      t.timestamps
    end
  end
end
