class Addnaictocarrier < ActiveRecord::Migration
  def up
    add_column :carriers, :naic_number, :string
  end

  def down
  end
end
