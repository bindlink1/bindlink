class CreateProducingagencies < ActiveRecord::Migration
  def change
    create_table :producingagencies do |t|

      t.timestamps
    end
  end
end
