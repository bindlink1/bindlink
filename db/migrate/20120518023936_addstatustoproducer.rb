class Addstatustoproducer < ActiveRecord::Migration
  def up

  add_column :producingagencies, :status ,:string
    add_column :producingagencies, :date_appointed ,:date
    add_column :producingagencies, :date_terminated ,:date
  end

  def down
  end
end
