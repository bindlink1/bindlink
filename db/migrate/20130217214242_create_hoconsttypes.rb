class CreateHoconsttypes < ActiveRecord::Migration
  def change
    create_table :hoconsttypes do |t|
      t.string :construction_type
      t.timestamps
    end
  end
end
