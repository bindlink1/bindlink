class Create5bis < ActiveRecord::Migration
  def up
    add_column :al3h5bis, :header, :string
    add_column :al3h5bis, :insureds_name, :string
    add_column :al3h5bis, :companys_id_for_insured, :string
    add_column :al3h5bis, :agencys_id_for_insured, :string
    add_column :al3h5bis, :legal_entity_code, :string
    add_column :al3h5bis, :number_of_member_and_managers, :integer
  end

  def down
  end
end
