class Fixbisids < ActiveRecord::Migration
  def up
          remove_column :al3h5bis, :al3h2trg_id
    remove_column :al3h9bis, :al3h2trg_id

    add_column :al3h5bis, :al3h2trg_id, :integer
    add_column :al3h9bis, :al3h2trg_id, :integer
  end

  def down
  end
end
