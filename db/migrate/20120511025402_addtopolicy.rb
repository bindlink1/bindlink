class Addtopolicy < ActiveRecord::Migration
  def up
    add_column :policies, :line_id,:integer
    add_column :policies, :coverage_id,:integer
    add_column :policies, :payment_type_id,:integer
    add_column :policies, :finance_company_id,:integer
    add_column :policies, :policy_number,:text
    add_column :policies, :expiration_date,:date
    add_column :policies, :agent_id,:integer
    add_column :policies, :description,:text
    add_column :policies, :status,:text
  end

  def down
  end
end
