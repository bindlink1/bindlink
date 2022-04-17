class Adddetailsproducercomm < ActiveRecord::Migration
  def up
      add_column :producercommissions, :policy_id, :integer
    add_column :producercommissions, :policypremiumtransaction_id, :integer

  end

  def down
  end
end
