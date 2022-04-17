class Addnamedinsuredtosub < ActiveRecord::Migration
  def up
    add_column :submissions, :named_insured, :string
  end

  def down
  end
end
