class Adddebitcredittoacctt < ActiveRecord::Migration
  def up
    add_column :accountingtransactions, :trans_type,:string
  end

  def down
  end
end
