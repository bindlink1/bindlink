class Editlookuphomeowner < ActiveRecord::Migration
  def up
    rename_column :homeownerpolicies, :construction_type, :hoconsttype_id
    rename_column :homeownerpolicies, :form, :hoform_id
  end

  def down
  end
end
