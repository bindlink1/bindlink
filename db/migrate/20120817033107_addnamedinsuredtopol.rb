class Addnamedinsuredtopol < ActiveRecord::Migration
  def up
    add_column :policies, :named_insured, :string
  end

  def down
  end
end
