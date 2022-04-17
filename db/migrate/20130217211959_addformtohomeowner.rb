class Addformtohomeowner < ActiveRecord::Migration
  def up
    add_column :homeownerpolicies, :form, :string
  end

  def down
  end
end
