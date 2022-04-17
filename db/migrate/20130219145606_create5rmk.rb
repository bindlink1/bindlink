class Create5rmk < ActiveRecord::Migration
  def up
       add_column :al3h5rmks, :header, :string
    add_column :al3h5rmks, :al3h5bpi_id, :integer
    add_column :al3h5rmks, :data_element_referenced, :string
    add_column :al3h5rmks, :remarks_number, :integer
    add_column :al3h5rmks, :remarks_impact_indicator, :string
    add_column :al3h5rmks, :remarks_text, :text


  end

  def down
  end
end
