class Addpaytoreturnbatchitems < ActiveRecord::Migration
  def up
    add_column :returnpremiumbatchitems, :pay_to_entity, :string
    add_column :returnpremiumbatchitems, :pfc_id, :integer
    add_column :returnpremiumbatchitems, :producingagency_id, :integer
    add_column :returnpremiumbatchitems, :client_id, :integer
  end

  def down
  end
end
