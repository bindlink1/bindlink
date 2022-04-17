class Addprocessedtobatch < ActiveRecord::Migration
  def up
    add_column :return_premium_batches, :status, :string
  end

  def down
  end
end
