class CreateProducercommissions < ActiveRecord::Migration
  def change
    create_table :producercommissions do |t|

      t.timestamps
    end
  end
end
