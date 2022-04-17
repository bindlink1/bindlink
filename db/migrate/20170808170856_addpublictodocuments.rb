class Addpublictodocuments < ActiveRecord::Migration
  def up
    add_column :documents, :public_flag, :boolean
  end

  def down
  end
end
