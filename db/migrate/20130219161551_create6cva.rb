class Create6cva < ActiveRecord::Migration
  def up
      add_column :al3h6cvas, :header, :string
    add_column :al3h6cvas, :al3h5veh_id, :integer
    add_column :al3h6cvas, :al3h5lag_id, :integer
    add_column :al3h6cvas, :coverage_code, :string
    add_column :al3h6cvas, :form_number, :string
    add_column :al3h6cvas, :limit1, :integer
    add_column :al3h6cvas, :limit2, :integer
    add_column :al3h6cvas, :deductible, :integer
    add_column :al3h6cvas, :deductible_type_code, :string
  end

  def down
  end
end
