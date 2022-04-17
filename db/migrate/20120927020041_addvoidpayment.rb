class Addvoidpayment < ActiveRecord::Migration
  def up
    add_column :cashtransactions, :void_flag, :string
  end

  def down
  end
end
