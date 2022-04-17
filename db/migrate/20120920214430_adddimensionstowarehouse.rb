class Adddimensionstowarehouse < ActiveRecord::Migration
  def up
    add_column  :reportingwarehouses, :yearrmo, :integer
    add_column  :reportingwarehouses, :policypremiumtransaction_id, :integer
    add_column  :reportingwarehouses, :carrier_id, :integer
    add_column  :reportingwarehouses, :lineofbusiness_id, :integer
    add_column  :reportingwarehouses, :producingagency_id, :integer
    add_column  :reportingwarehouses, :agent_id, :integer
    add_column  :reportingwarehouses, :location_id, :integer
    add_column  :reportingwarehouses, :expired_count, :integer

  end

  def down
  end
end
