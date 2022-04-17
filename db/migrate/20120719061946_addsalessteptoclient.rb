class Addsalessteptoclient < ActiveRecord::Migration
  def up
    add_column :clients, :sales_step, :string
    add_column :clients, :client_source, :integer
  end

  def down
  end
end
