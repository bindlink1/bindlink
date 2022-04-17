class CreateCustomdocumentfieldgroups < ActiveRecord::Migration
  def change
    create_table :customdocumentfieldgroups do |t|

      t.timestamps
    end
  end
end
