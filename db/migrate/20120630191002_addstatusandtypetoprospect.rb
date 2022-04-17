class Addstatusandtypetoprospect < ActiveRecord::Migration
  def up
    add_column :prospects, :customer_type, :string
    add_column :prospects, :prospect_status, :string
    add_column :prospects, :referral_source, :string
  end

  def down
  end
end
