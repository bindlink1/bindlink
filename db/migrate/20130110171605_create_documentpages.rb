class CreateDocumentpages < ActiveRecord::Migration
  def change
    create_table :documentpages do |t|

      t.timestamps
    end
  end
end
