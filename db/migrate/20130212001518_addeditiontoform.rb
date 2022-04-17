class Addeditiontoform < ActiveRecord::Migration
  def up
    add_column :acordforms, :form_edition, :string
  end

  def down
  end
end
