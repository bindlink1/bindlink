class Addlobto5bpi < ActiveRecord::Migration
  def up
    add_column :al3h5bpis, :line_of_business_code, :string
    add_column :al3h5bpis, :line_of_business_subcode, :string
  end

  def down
  end
end
