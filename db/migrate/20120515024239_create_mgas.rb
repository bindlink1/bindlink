class CreateMgas < ActiveRecord::Migration
  def change
    create_table :mgas do |t|

      t.timestamps
    end
  end
end
