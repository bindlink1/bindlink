class Adddetailstoproducercomm < ActiveRecord::Migration
  def up
    add_column :producercommissions, :commission_value, :decimal
    add_column :producercommissions, :transaction_type, :string
    add_column :producercommissions, :producer_id, :integer
    add_column :producercommissions, :generalagency_id, :integer
    add_column :producercommissions, :book_month, :integer
    add_column :producercommissions, :book_year, :integer
  end

  def down
  end
end
