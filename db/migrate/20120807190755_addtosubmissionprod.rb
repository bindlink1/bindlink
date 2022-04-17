class Addtosubmissionprod < ActiveRecord::Migration
  def up
    add_column :submissions, :producingagency_id, :integer
  end

  def down
  end
end
