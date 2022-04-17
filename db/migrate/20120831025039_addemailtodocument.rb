class Addemailtodocument < ActiveRecord::Migration
  def up
    add_column :documents, :inboundemail_id, :integer
  end

  def down
  end
end
