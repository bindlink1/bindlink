class Conversionhelpers < ActiveRecord::Migration
  def up
    add_column :namedinsureds, :old_id_int, :integer
    add_column :namedinsureds, :old_id_txt, :string
    add_column :policies, :old_id_int, :integer
    add_column :policies, :old_id_txt, :string

  end

  def down
  end
end
