class Addconditionalcomm < ActiveRecord::Migration
  def up

    add_column :policies, :cond_comm_producer, :decimal
    add_column :policies, :cond_comm_generalagency, :decimal
  end

  def down
  end
end
