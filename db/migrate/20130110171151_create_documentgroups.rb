class CreateDocumentgroups < ActiveRecord::Migration
  def change
    create_table :documentgroups do |t|

      t.timestamps
    end
  end
end
