class Addtocarrieradressstatus < ActiveRecord::Migration
  def up
    add_column :carriers, :web_url, :string
    add_column :carriers, :status, :string
  end

  def down
  end
end
