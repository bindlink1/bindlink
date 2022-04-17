class CreateCommissions < ActiveRecord::Migration
  def change
    create_table :commissions do |t|

      t.timestamps
    end
  end
end
