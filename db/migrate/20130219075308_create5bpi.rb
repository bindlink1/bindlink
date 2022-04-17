class Create5bpi < ActiveRecord::Migration
  def up
    add_column :al3h5bpis, :header, :string
    add_column :al3h5bpis, :al3h2trg_id, :integer
    add_column :al3h5bpis, :al3h5bis_id , :integer
    add_column :al3h5bpis, :policy_number, :string
    add_column :al3h5bpis, :original_policy_inception_date, :date
    add_column :al3h5bpis, :renewal_term, :integer
    add_column :al3h5bpis, :current_term_amount, :decimal
    add_column :al3h5bpis, :net_change_amount, :decimal
     add_column :al3h5bpis, :policy_effective_date, :date
    add_column :al3h5bpis, :policy_expiration_date, :date
    add_column :al3h5bpis, :commission_premium, :decimal
    add_column :al3h5bpis, :minimum_premium, :decimal


  end


  def down
  end
end
