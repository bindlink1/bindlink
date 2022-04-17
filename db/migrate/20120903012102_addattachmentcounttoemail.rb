class Addattachmentcounttoemail < ActiveRecord::Migration
  def up
    add_column  :inboundemails, :attachment_count, :integer
  end

  def down
  end
end
