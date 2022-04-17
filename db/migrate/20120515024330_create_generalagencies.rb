class CreateGeneralagencies < ActiveRecord::Migration
  def change
    create_table :generalagencies do |t|

      t.timestamps
    end
  end
end
