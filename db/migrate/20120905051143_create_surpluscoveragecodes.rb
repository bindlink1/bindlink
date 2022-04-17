class CreateSurpluscoveragecodes < ActiveRecord::Migration
  def change
    create_table :surpluscoveragecodes do |t|
      t.string :coverage_description
      t.integer :coverage_code
      t.timestamps
    end
  end
end
