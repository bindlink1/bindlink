class CreateProspects < ActiveRecord::Migration
  def change
    create_table :prospects do |t|

      t.timestamps
    end
  end
end
