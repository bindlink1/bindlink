class Addoriginalexptopolicy < ActiveRecord::Migration
  def up
    add_column :policies, :original_expiration_date, :date
  end

  def down
  end
end
