class Addstatustoquote < ActiveRecord::Migration
  def up
    add_column :quotes, :status, :string
  end

  def down
  end
end
