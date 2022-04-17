class Addpagestoformfields < ActiveRecord::Migration
  def up
    add_column :acordformfields, :page, :integer
    add_column :acordforms, :form_description, :string
    add_column :acordformfields, :data_type, :string
  end

  def down
  end
end
