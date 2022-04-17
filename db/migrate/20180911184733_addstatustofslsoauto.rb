class Addstatustofslsoauto < ActiveRecord::Migration
  def change
    add_column :fslsoauto, :status, :string
    add_column :fslsoauto, :submissionno, :string
    add_column :fslsoauto, :updated_at, :datetime
  end
end
