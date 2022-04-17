class Addcolumnsto2trg < ActiveRecord::Migration
  def up
    add_column :al3h2trgs, :header, :string
    add_column :al3h2trgs, :transaction_structure_standard_vers_number, :string
    add_column :al3h2trgs, :application_software_revision_level, :string
    add_column :al3h2trgs, :transaction_image, :string
    add_column :al3h2trgs, :automation_level, :string
    add_column :al3h2trgs, :transaction_category, :string
    add_column :al3h2trgs, :policy_type_routing_code, :string
    add_column :al3h2trgs, :line_of_business_routing_code, :string
    add_column :al3h2trgs, :transaction_function, :string
    add_column :al3h2trgs, :processing_cycle_status, :string
    add_column :al3h2trgs, :initial_transaction_mode, :string
    add_column :al3h2trgs, :special_response_option, :string
    add_column :al3h2trgs, :error_processing_option, :string
    add_column :al3h2trgs, :formal_transaction_address_sender, :string
    add_column :al3h2trgs, :informal_transaction_address_sender, :string
    add_column :al3h2trgs, :formal_transaction_address_recipient, :string
    add_column :al3h2trgs, :informal_transaction_address_recipient, :string
    add_column :al3h2trgs, :special_handling, :string
    add_column :al3h2trgs, :origination_reference_information, :string
    add_column :al3h2trgs, :transaction_sequence_number, :integer
    add_column :al3h2trgs, :processing_cycle_number, :integer
    add_column :al3h2trgs, :reference_transaction_sequence_number, :integer
    add_column :al3h2trgs, :response_automation_level, :string
    add_column :al3h2trgs, :cycle_business_purpose, :string
    add_column :al3h2trgs, :synchronation_field, :string
    add_column :al3h2trgs, :segment_level_code, :string
    add_column :al3h2trgs, :segmented_transaction_counter, :integer
    add_column :al3h2trgs, :segmented_transaction_total_pieces, :integer
    add_column :al3h2trgs, :quote_date, :date
    add_column :al3h2trgs, :transaction_date, :date
    add_column :al3h2trgs, :transaction_effective_date, :date
  end

  def down
  end
end
