class CreateWorkitems < ActiveRecord::Migration
  def change
    create_table :workitems do |t|

      t.timestamps
    end
  end
end
