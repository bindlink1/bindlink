class Addhurricanetoho < ActiveRecord::Migration
  def up
    add_column  :homeownerpolicies, :hurricane_deductible, :string
    add_column  :homeownerpolicies, :deductible, :string
  end

  def down
  end
end
