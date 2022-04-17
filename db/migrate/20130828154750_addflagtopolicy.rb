class Addflagtopolicy < ActiveRecord::Migration
  def up
    add_column :policies, :policy_flag, :boolean
    add_column :policies, :flag_note, :string
  end

  def down
  end
end
