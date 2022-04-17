# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20181010184734) do

  create_table "accountingaccounts", :force => true do |t|
    t.integer  "account_id"
    t.text     "account_name"
    t.text     "balance_sheet"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "contra_account_id"
    t.integer  "contra_account_ref_id"
  end

  create_table "accountingtransactions", :force => true do |t|
    t.integer  "account_id"
    t.integer  "invoice_id"
    t.integer  "invoice_item_id"
    t.decimal  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "policy_id"
    t.string   "trans_type"
    t.integer  "policypremiumtransaction_id"
    t.integer  "book_month"
    t.integer  "book_year"
    t.integer  "agency_id"
    t.integer  "generalagency_id"
    t.integer  "cashtransaction_id"
    t.string   "reconcile_flag"
    t.date     "book_date"
    t.date     "transaction_effective_date"
    t.integer  "effective_month"
    t.integer  "effective_year"
  end

  create_table "acord_xml_coverages", :force => true do |t|
    t.integer  "acord_xml_pers_veh_id"
    t.string   "coverage_cd"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "acord_xml_deductibles", :force => true do |t|
    t.integer  "acord_xml_coverage_id"
    t.string   "deductible_type_cd"
    t.string   "deductible_applies_to_cd"
    t.integer  "deductible_amt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "acord_xml_driver_vehs", :force => true do |t|
    t.integer  "acord_xml_pers_policy_id"
    t.integer  "acord_xml_pers_driver_id"
    t.integer  "acord_xml_pers_veh_id"
    t.integer  "use_pct"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "acord_xml_general_party_infos", :force => true do |t|
    t.integer  "acord_xml_producer_id"
    t.integer  "acord_xml_insured_or_principal_id"
    t.string   "surname"
    t.string   "given_name"
    t.string   "tax_id_type_cd"
    t.string   "tax_id"
    t.string   "addr_type_cd"
    t.string   "addr_1"
    t.string   "addr_2"
    t.string   "city"
    t.string   "county"
    t.string   "state_prov_cd"
    t.string   "postal_code"
    t.string   "phone_type_cd"
    t.string   "communication_use_cd"
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "acord_xml_insured_or_principals", :force => true do |t|
    t.integer  "acord_xml_pers_auto_policy_id"
    t.string   "insured_or_principal_role_cd"
    t.string   "gender_cd"
    t.date     "birth_dt"
    t.string   "marital_status_cd"
    t.string   "occupation_class_cd"
    t.string   "length_time_with_previous_employer"
    t.string   "relationship_cd"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "acord_xml_limits", :force => true do |t|
    t.integer  "acord_xml_coverage_id"
    t.integer  "limit_amt"
    t.string   "limit_applies_to_cd"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "acord_xml_locations", :force => true do |t|
    t.integer  "acord_xml_pers_auto_policy_id"
    t.string   "addr_type_cd"
    t.string   "addr_1"
    t.string   "city"
    t.string   "county"
    t.string   "state_prov_cd"
    t.string   "postal_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "acord_xml_options", :force => true do |t|
    t.integer  "acord_xml_coverage_id"
    t.string   "option_cd"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "acord_xml_other_or_prior_policies", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "acord_xml_pers_auto_line_businesses", :force => true do |t|
    t.integer  "acord_xml_pers_auto_policy_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "acord_xml_pers_auto_policies", :force => true do |t|
    t.integer  "policy_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "acord_xml_pers_drivers", :force => true do |t|
    t.integer  "acord_xml_pers_auto_line_business_id"
    t.string   "gender_cd"
    t.date     "birth_dt"
    t.string   "marital_status_cd"
    t.string   "occupation_class_cd"
    t.string   "license_status_cd"
    t.date     "license_dt"
    t.string   "driver_license_number"
    t.string   "state_prov_cd"
    t.string   "veh_principally_driven_ref"
    t.string   "resident_custody_ind"
    t.string   "driver_type"
    t.string   "driver_relationship_to_applicant_cd"
    t.string   "mature_driver_ind"
    t.string   "driver_training_ind"
    t.string   "good_student_cd"
    t.string   "good_driver_ind"
    t.string   "distant_student_ind"
    t.string   "filing_status_cd"
    t.string   "license_suspended_revoked_ind"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "acord_xml_general_party_info_id"
  end

  create_table "acord_xml_pers_policies", :force => true do |t|
    t.integer  "acord_xml_pers_auto_policy_id"
    t.string   "lob_cd"
    t.string   "billing_method_cd"
    t.date     "effective_dt"
    t.string   "residence_type_cd"
    t.integer  "length_years"
    t.integer  "length_months"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "acord_xml_pers_vehs", :force => true do |t|
    t.integer  "acord_xml_pers_auto_line_business_id"
    t.string   "model_year"
    t.string   "manufacturer"
    t.string   "model"
    t.string   "veh_identification_number"
    t.string   "anti_lock_brake_cd"
    t.string   "anti_theft_device_cd"
    t.integer  "present_value_amt"
    t.integer  "cost_new_amt"
    t.integer  "distance_one_way"
    t.integer  "estimated_annual_distance"
    t.string   "ownership"
    t.string   "carpool_ind"
    t.integer  "num_days_driven_per_week"
    t.integer  "length_time_per_month"
    t.string   "air_bag_type_cd"
    t.string   "veh_performance_cd"
    t.string   "veh_use_cd"
    t.string   "existing_unrepaired_damage_ind"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "daytime_running_light_ind"
  end

  create_table "acord_xml_producers", :force => true do |t|
    t.integer  "acord_xml_pers_auto_policy_id"
    t.string   "agency_id"
    t.string   "surname"
    t.string   "given_name"
    t.string   "tax_id_type_cd"
    t.string   "tax_id"
    t.string   "addr_type_cd"
    t.string   "addr_1"
    t.string   "addr_2"
    t.string   "city"
    t.string   "county"
    t.string   "state_prov_cd"
    t.string   "postal_code"
    t.string   "phone_type_cd"
    t.string   "communication_use_cd"
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "acordfieldvalues", :force => true do |t|
    t.integer  "acordform_id"
    t.integer  "acordformfield_id"
    t.integer  "acordforminstance_id"
    t.string   "fielddata"
    t.integer  "agent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "acordformfields", :force => true do |t|
    t.integer  "acordform_id"
    t.string   "formfieldname"
    t.integer  "width"
    t.integer  "height"
    t.integer  "xpos"
    t.integer  "ypos"
    t.text     "help"
    t.string   "prevformfieldname"
    t.string   "nextformfieldname"
    t.string   "fieldtype"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "page"
    t.string   "data_type"
  end

  create_table "acordforminstances", :force => true do |t|
    t.integer  "acordform_id"
    t.integer  "agent_id"
    t.integer  "agency_id"
    t.integer  "generalagency_id"
    t.integer  "policy_id"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "acordforms", :force => true do |t|
    t.string   "form_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "numberofpages"
    t.string   "form_description"
    t.string   "form_edition"
    t.boolean  "active"
  end

  create_table "admins", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "agency_name"
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "agencies", :force => true do |t|
    t.string   "agency_name"
    t.string   "address_1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "telephone"
    t.string   "principal"
    t.string   "license_number"
    t.boolean  "approved"
    t.date     "approved_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "docfolder"
  end

  create_table "agents", :force => true do |t|
    t.string   "email",                  :default => "",   :null => false
    t.string   "encrypted_password",     :default => "",   :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "agency_name"
    t.integer  "agency_id"
    t.integer  "generalagency_id"
    t.string   "outboundemail"
    t.boolean  "is_admin"
    t.boolean  "is_active",              :default => true, :null => false
  end

  add_index "agents", ["email"], :name => "index_agents_on_email", :unique => true
  add_index "agents", ["reset_password_token"], :name => "index_agents_on_reset_password_token", :unique => true

  create_table "al3cyclebusinesspurposes", :force => true do |t|
    t.string   "code_value"
    t.string   "code_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "al3files", :force => true do |t|
    t.integer  "agency_id"
    t.date     "file_received_date"
    t.string   "file_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "processed"
  end

  create_table "al3h2tcgs", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "al3h2trgs", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "header"
    t.string   "transaction_structure_standard_vers_number"
    t.string   "application_software_revision_level"
    t.string   "transaction_image"
    t.string   "automation_level"
    t.string   "transaction_category"
    t.string   "policy_type_routing_code"
    t.string   "line_of_business_routing_code"
    t.string   "transaction_function"
    t.string   "processing_cycle_status"
    t.string   "initial_transaction_mode"
    t.string   "special_response_option"
    t.string   "error_processing_option"
    t.string   "formal_transaction_address_sender"
    t.string   "informal_transaction_address_sender"
    t.string   "formal_transaction_address_recipient"
    t.string   "informal_transaction_address_recipient"
    t.string   "special_handling"
    t.string   "origination_reference_information"
    t.integer  "transaction_sequence_number"
    t.integer  "processing_cycle_number"
    t.integer  "reference_transaction_sequence_number"
    t.string   "response_automation_level"
    t.string   "cycle_business_purpose"
    t.string   "synchronation_field"
    t.string   "segment_level_code"
    t.integer  "segmented_transaction_counter"
    t.integer  "segmented_transaction_total_pieces"
    t.date     "quote_date"
    t.date     "transaction_date"
    t.date     "transaction_effective_date"
  end

  create_table "al3h5aois", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "al3h5bis", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "header"
    t.string   "insureds_name"
    t.string   "companys_id_for_insured"
    t.string   "agencys_id_for_insured"
    t.string   "legal_entity_code"
    t.integer  "number_of_member_and_managers"
    t.integer  "al3h2trg_id"
  end

  create_table "al3h5bpis", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "header"
    t.integer  "al3h2trg_id"
    t.integer  "al3h5bis_id"
    t.string   "policy_number"
    t.date     "original_policy_inception_date"
    t.integer  "renewal_term"
    t.decimal  "current_term_amount"
    t.decimal  "net_change_amount"
    t.date     "policy_effective_date"
    t.date     "policy_expiration_date"
    t.decimal  "commission_premium"
    t.decimal  "minimum_premium"
    t.string   "company_code"
    t.string   "line_of_business_code"
    t.string   "line_of_business_subcode"
    t.decimal  "nominal_term_amount"
    t.decimal  "written_amount"
  end

  create_table "al3h5drvs", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "header"
    t.integer  "al3h5bpi_id"
    t.string   "drivers_name"
    t.date     "date_of_birth"
    t.string   "driver_sex_code"
    t.string   "licensed_state"
    t.string   "social_security_number"
    t.string   "drivers_license_number"
    t.string   "driver_type_code"
  end

  create_table "al3h5fors", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "al3h5lags", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "header"
    t.integer  "al3h5bpi_id"
    t.integer  "location_number"
    t.string   "street_address_line1"
    t.string   "street_address_line2"
    t.string   "city"
    t.string   "state_abbreviation"
    t.string   "zip_code"
    t.string   "county_name"
  end

  create_table "al3h5pays", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "al3h5pphs", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "al3h5pts", :force => true do |t|
    t.integer  "al3h2trg_id"
    t.integer  "line_number"
    t.text     "line_content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "al3h5rmks", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "header"
    t.integer  "al3h5bpi_id"
    t.string   "data_element_referenced"
    t.integer  "remarks_number"
    t.string   "remarks_impact_indicator"
    t.text     "remarks_text"
  end

  create_table "al3h5vehs", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "header"
    t.integer  "al3h5lag_id"
    t.integer  "company_vehicle_number"
    t.integer  "agency_vehicle_number"
    t.integer  "vehicle_year"
    t.string   "vehicle_make"
    t.string   "vehicle_model"
    t.string   "vin"
    t.string   "vehicle_registration_state"
    t.integer  "cost_new"
  end

  create_table "al3h6cvas", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "header"
    t.integer  "al3h5veh_id"
    t.integer  "al3h5lag_id"
    t.string   "coverage_code"
    t.string   "form_number"
    t.integer  "limit1"
    t.integer  "limit2"
    t.integer  "deductible"
    t.string   "deductible_type_code"
  end

  create_table "al3h6pdas", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "al3h6pdrs", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "al3h6pvhs", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "al3h9aois", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "al3h9bis", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "header"
    t.string   "street_address_line1"
    t.string   "street_address_line2"
    t.string   "city"
    t.string   "state_abbreviation"
    t.string   "zip_code"
    t.string   "insureds_telephone_number"
    t.string   "insureds_alternate_telephone_number"
    t.string   "county_name"
    t.string   "tax_code"
    t.string   "country_name_code"
    t.string   "insureds_telephone_number_type_code"
    t.string   "address_line3"
    t.string   "address_line4"
    t.string   "insureds_alternate_telephone_number_type_code"
    t.string   "insureds_telephone_number_extension"
    t.string   "insureds_alternate_telephone_number_extension"
    t.string   "coinsureds_telephone_number"
    t.string   "coinsureds_alternate_telephone_number"
    t.string   "coinsureds_telephone_number_extension"
    t.string   "coinsureds_alternate_telephone_number_extension"
    t.string   "insureds_alternate_telephone_number_2"
    t.string   "insureds_alternate_telephone_number_2_type_code"
    t.string   "insureds_alternate_telephone_number_2_extension"
    t.string   "education_level_code"
    t.string   "citizenship_country"
    t.integer  "al3h2trg_id"
  end

  create_table "al3transactions", :force => true do |t|
    t.integer  "al3file_id"
    t.string   "transaction_function"
    t.integer  "carrier_id"
    t.date     "transaction_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cycle_business_purpose"
    t.integer  "al3h2trg_id"
    t.date     "transaction_effective_date"
    t.integer  "agency_id"
    t.boolean  "processed"
    t.integer  "policy_id"
  end

  create_table "announcements", :force => true do |t|
    t.text     "message"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "applications", :force => true do |t|
    t.string   "named_insured"
    t.integer  "premium"
    t.date     "bound"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "appointments", :force => true do |t|
    t.integer  "agency_id"
    t.integer  "quotingentity_id"
    t.date     "active_on"
    t.date     "exipiration_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "billingtypes", :force => true do |t|
    t.integer  "billing_type_id"
    t.string   "billing_type_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "group"
  end

  create_table "carrierlobs", :force => true do |t|
    t.integer  "carrier_id"
    t.integer  "lineofbusiness_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "carriernaics", :force => true do |t|
    t.integer  "carrier_id"
    t.string   "naic_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "agency_id"
  end

  create_table "carriers", :force => true do |t|
    t.string   "carrier_name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.decimal  "commission_percent"
    t.string   "billing_type"
    t.integer  "agency_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "marketing_contact"
    t.string   "marketing_telephone"
    t.string   "marketing_email"
    t.string   "underwriting_contact"
    t.string   "underwriting_telephone"
    t.string   "underwriting_email"
    t.string   "agency_code"
    t.date     "date_appointed"
    t.integer  "days_invoice_due"
    t.string   "naic_number"
    t.string   "admitted_status"
    t.integer  "statementgroup_id"
    t.boolean  "isstatementgroup"
    t.string   "web_url"
    t.string   "status"
    t.integer  "generalagency_id"
  end

  create_table "cashtransactions", :force => true do |t|
    t.integer  "invoice_id"
    t.decimal  "cash_amount"
    t.string   "payment_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "book_month"
    t.integer  "book_year"
    t.integer  "policy_id"
    t.string   "transaction_type"
    t.integer  "agency_id"
    t.integer  "generalagency_id"
    t.string   "nsf_flag"
    t.string   "transfer_flag"
    t.string   "reversed_flag"
    t.integer  "agent_id"
    t.integer  "return_premium_batch_id"
    t.integer  "returnpremiumbatchitem_id"
    t.string   "check_number"
    t.integer  "producingagency_id"
    t.integer  "client_id"
    t.integer  "carrier_id"
    t.integer  "pfc_id"
    t.string   "void_flag"
    t.integer  "compaybatchitem_id"
    t.date     "transaction_effective_date"
    t.date     "book_date"
    t.integer  "effective_month"
    t.integer  "effective_year"
    t.integer  "policypremiumtransaction_id"
  end

  create_table "checklistitems", :force => true do |t|
    t.integer  "checklist_id"
    t.string   "task_type"
    t.string   "task_name"
    t.integer  "agent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "checklists", :force => true do |t|
    t.integer  "lobcommission_id"
    t.integer  "agent_id"
    t.string   "checklist_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "agency_id"
    t.integer  "generalagency_id"
  end

  create_table "clientaddresses", :force => true do |t|
    t.integer  "client_id"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "address_type"
    t.string   "note"
    t.integer  "clientcontact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clientcontacts", :force => true do |t|
    t.integer  "client_id"
    t.string   "contact_type"
    t.string   "contact_value"
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_ssn"
    t.string   "encrypted_ssn_salt"
    t.string   "encrypted_ssn_iv"
    t.string   "encrypted_dlnum"
    t.string   "encrypted_dlnum_salt"
    t.string   "encrypted_dlnum_iv"
    t.string   "dlstate"
    t.date     "dlexp"
    t.date     "birth_date"
    t.string   "sex"
    t.string   "occupation"
  end

  create_table "clientphoneemails", :force => true do |t|
    t.integer  "client_id"
    t.string   "contact_type"
    t.string   "contact_value"
    t.string   "note"
    t.integer  "clientcontact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients", :force => true do |t|
    t.string   "client_name"
    t.string   "address_1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "telephone"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "agent_id"
    t.integer  "agency_id"
    t.string   "mailing_address_1"
    t.string   "mailing_address_2"
    t.string   "mailing_city"
    t.string   "mailing_state"
    t.string   "mailing_zip"
    t.string   "email"
    t.integer  "producingagency_id"
    t.integer  "generalagency_id"
    t.string   "contactname_1"
    t.string   "contactname_2"
    t.string   "contactname_3"
    t.string   "home_phone"
    t.string   "home_phone_2"
    t.string   "cell_phone"
    t.string   "cell_phone_2"
    t.string   "fax_phone"
    t.integer  "prospect_id"
    t.integer  "location_id"
    t.string   "client_type"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "corporate_name"
    t.string   "client_status"
    t.string   "sales_step"
    t.integer  "client_source"
    t.integer  "referer_id"
  end

  create_table "commissions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "compay_batches", :force => true do |t|
    t.integer  "generalagency_id"
    t.decimal  "batch_total"
    t.integer  "transaction_count"
    t.integer  "check_start"
    t.integer  "check_end"
    t.integer  "agent_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "compaybatchitems", :force => true do |t|
    t.integer  "policy_id"
    t.integer  "compay_batch_id"
    t.integer  "cashtransaction_id"
    t.integer  "producingagency_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "compaybatchpreitems", :force => true do |t|
    t.integer  "policy_id"
    t.integer  "compay_batch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conversations", :force => true do |t|
    t.integer  "submission_id"
    t.integer  "underwriter_id"
    t.integer  "quotingentity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "agency_id"
    t.integer  "agent_id"
  end

  create_table "customdocumentfieldgroups", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customdocumentfieldrepeats", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "customdocument_id"
    t.string   "field_model"
    t.string   "field_name"
    t.string   "title_name"
    t.string   "title_model"
    t.integer  "location_x"
    t.integer  "location_y"
    t.string   "field_type"
  end

  create_table "customdocumentfields", :force => true do |t|
    t.integer  "customdocument_id"
    t.string   "field_name"
    t.string   "field_model"
    t.integer  "location_x"
    t.integer  "location_y"
    t.integer  "font_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attribute_name"
    t.string   "field_type"
  end

  create_table "customdocuments", :force => true do |t|
    t.integer  "agency_id"
    t.integer  "generalagency_id"
    t.string   "document_name"
    t.string   "file_name"
    t.string   "document_model"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customfields", :force => true do |t|
    t.integer  "agency_id"
    t.integer  "producingagency_id"
    t.string   "field_name"
    t.string   "field_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "associated_with"
    t.boolean  "encrypt"
  end

  create_table "customfieldvalues", :force => true do |t|
    t.string   "value"
    t.date     "value_date"
    t.decimal  "value_number"
    t.integer  "customfield_id"
    t.integer  "client_id"
    t.integer  "policy_id"
    t.integer  "producingagency_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_evalue"
    t.string   "encrypted_evalue_salt"
    t.string   "encrypted_evalue_iv"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "documentgroups", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documentpages", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "document_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.integer  "agency_id"
    t.integer  "generalagency_id"
    t.integer  "page_number"
  end

  create_table "documents", :force => true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.date     "image_updated_at"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "policy_id"
    t.string   "type"
    t.string   "name"
    t.integer  "agent_id"
    t.integer  "client_id"
    t.integer  "producingagency_id"
    t.integer  "quote_id"
    t.integer  "submission_id"
    t.integer  "inboundemail_id"
    t.integer  "generalagency_id"
    t.integer  "agency_id"
    t.string   "doctype"
    t.datetime "hashvalidtill"
  end

  create_table "emails", :force => true do |t|
    t.integer  "agent_id"
    t.string   "client_id"
    t.string   "from"
    t.string   "to"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "document_id"
  end

  create_table "fees", :force => true do |t|
    t.integer  "agency_id"
    t.integer  "generalagency_id"
    t.string   "fee_name"
    t.string   "fee_type"
    t.integer  "lineofbusiness_id"
    t.string   "state"
    t.decimal  "fee_value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fee_remit_type"
    t.string   "earn_type"
    t.string   "attach_type"
    t.date     "effective_date"
    t.date     "expiration_date"
  end

  create_table "feetransactions", :force => true do |t|
    t.integer  "lobfee_id"
    t.integer  "policypremiumtransaction_id"
    t.integer  "policy_id"
    t.decimal  "fee_amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "fee_id"
  end

  create_table "fslsoauto", :force => true do |t|
    t.datetime "created_at",                :null => false
    t.datetime "period_start",              :null => false
    t.datetime "period_end",                :null => false
    t.boolean  "success",                   :null => false
    t.string   "type",         :limit => 6
    t.text     "message"
    t.string   "status"
    t.string   "submissionno"
    t.datetime "updated_at"
  end

  create_table "fslsodata", :force => true do |t|
    t.string   "policy_number"
    t.string   "insured_name"
    t.string   "county"
    t.string   "postal_code"
    t.date     "effective_date"
    t.date     "expiration_date"
    t.date     "issue_date"
    t.integer  "coverage_code"
    t.integer  "transaction_type"
    t.string   "insurer_name"
    t.string   "naic_number"
    t.decimal  "premium"
    t.decimal  "policy_fee"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "generalagencies", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "agency_name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "telephone"
    t.string   "docfolder"
    t.string   "surpluslines_agent_name"
    t.string   "surpluslines_agent_license"
  end

  create_table "gllosscosts", :force => true do |t|
    t.integer  "class_code"
    t.string   "state"
    t.decimal  "premops"
    t.decimal  "prodcops"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "helpers", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "helpers", ["email"], :name => "index_helpers_on_email", :unique => true
  add_index "helpers", ["reset_password_token"], :name => "index_helpers_on_reset_password_token", :unique => true

  create_table "hoconsttypes", :force => true do |t|
    t.string   "construction_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hoforms", :force => true do |t|
    t.string   "form_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "homeownerpolicies", :force => true do |t|
    t.integer  "policy_id"
    t.decimal  "dwelling_coverage"
    t.decimal  "otherstructure_coverage"
    t.decimal  "lossofuse_coverage"
    t.decimal  "contents_coverage"
    t.decimal  "additionalliving_coverage"
    t.decimal  "liability_coverage"
    t.decimal  "medpay_coverage"
    t.string   "hoconsttype_id"
    t.integer  "year_built"
    t.integer  "sq_footage"
    t.integer  "number_rooms"
    t.integer  "roof_age"
    t.boolean  "alarm"
    t.boolean  "swimming_pool"
    t.boolean  "fire_station"
    t.boolean  "replacement_cost"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "hurricane_deductible"
    t.string   "deductible"
    t.string   "usage"
    t.string   "hoform_id"
  end

  create_table "inboundemails", :force => true do |t|
    t.integer  "agency_id"
    t.string   "sender"
    t.string   "from"
    t.string   "subject"
    t.text     "stripped_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "attachment_count"
    t.integer  "generalagency_id"
    t.integer  "policy_id"
    t.integer  "client_id"
    t.integer  "submission_id"
    t.integer  "read_flag"
    t.integer  "assigned_flag"
  end

  create_table "increasedlimitfactors", :force => true do |t|
    t.integer  "class_code"
    t.string   "state"
    t.integer  "aggregate"
    t.integer  "per_occurence"
    t.decimal  "increased_factor"
    t.string   "table_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoiceitems", :force => true do |t|
    t.integer  "invoice_id"
    t.decimal  "total_billed"
    t.decimal  "commission"
    t.decimal  "fees"
    t.decimal  "taxes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices", :force => true do |t|
    t.integer  "policy_id"
    t.date     "created_on"
    t.date     "due_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "total_billed"
    t.decimal  "commission"
    t.decimal  "fees"
    t.decimal  "taxes"
    t.decimal  "base_premium"
    t.decimal  "down_payment"
    t.decimal  "comm_fees"
    t.decimal  "non_comm_fees"
    t.integer  "book_month"
    t.integer  "book_year"
    t.integer  "policypremiumtransaction_id"
    t.string   "description"
    t.integer  "agency_id"
    t.integer  "generalagency_id"
    t.integer  "producingagency_id"
    t.decimal  "current_balance"
  end

  create_table "journalentries", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "amount"
    t.string   "trans_type"
    t.integer  "accountingaccount_id"
    t.integer  "policy_id"
  end

  create_table "lineofbusinesses", :force => true do |t|
    t.integer  "agency_id"
    t.integer  "generalagency_id"
    t.string   "line_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "billing_type"
    t.integer  "coverage_code"
    t.string   "lobbroadcategory_id"
  end

  create_table "lobbroadcategories", :force => true do |t|
    t.integer  "agency_id"
    t.integer  "generalagency_id"
    t.string   "category_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lobcommissions", :force => true do |t|
    t.integer  "carrierlob_id"
    t.string   "state"
    t.decimal  "commission_rate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "agency_id"
    t.integer  "generalagency_id"
    t.decimal  "producer_rate"
    t.integer  "billing_type"
    t.decimal  "commission_rate_renew"
    t.boolean  "enabled",               :default => true, :null => false
  end

  create_table "lobfees", :force => true do |t|
    t.integer  "lineofbusiness_id"
    t.integer  "fee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location_nickname"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.string   "fax"
    t.integer  "agency_id"
    t.integer  "generalagency_id"
    t.boolean  "main_location_flag"
  end

  create_table "message_templates", :force => true do |t|
    t.string "name"
    t.string "content"
  end

  create_table "mgas", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "namedinsureds", :force => true do |t|
    t.integer  "generalagency_id"
    t.integer  "producingagency_id"
    t.string   "named_insured"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "submission_id"
    t.integer  "policy_id"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.integer  "old_id_int"
    t.string   "old_id_txt"
  end

  create_table "notes", :force => true do |t|
    t.integer  "policy_id"
    t.integer  "client_id"
    t.text     "notetext"
    t.integer  "agent_id"
    t.integer  "agency_id"
    t.integer  "prospect_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "generalagency_id"
    t.integer  "quote_id"
    t.integer  "submission_id"
    t.date     "reminder_date"
    t.string   "note_type"
    t.integer  "producingagency_id"
  end

  create_table "onlinequotes", :force => true do |t|
    t.string   "named_insured"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pfcs", :force => true do |t|
    t.string   "pfc_name"
    t.string   "address"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "date"
    t.string   "telephone"
    t.string   "agency_code"
    t.string   "marketing_contact"
    t.string   "marketing_telephone"
    t.string   "marketing_email"
    t.string   "contact"
    t.string   "contact_telephone"
    t.string   "contact_email"
    t.integer  "agency_id"
    t.integer  "generalagency_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "zip"
  end

  create_table "policies", :force => true do |t|
    t.integer  "agency_id"
    t.integer  "client_id"
    t.integer  "carrier_id"
    t.integer  "mga_id"
    t.text     "policy_type"
    t.date     "effective_date"
    t.string   "policy_term"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "lineofbusiness_id"
    t.string   "coverage_id"
    t.integer  "payment_type_id"
    t.integer  "finance_company_id"
    t.text     "policy_number"
    t.date     "expiration_date"
    t.integer  "agent_id"
    t.text     "description"
    t.text     "status"
    t.integer  "generalagency_id"
    t.integer  "producingagency_id"
    t.date     "pfc_date_due"
    t.integer  "pfc_id"
    t.string   "pfc_contract"
    t.string   "state"
    t.integer  "location_id"
    t.string   "named_insured"
    t.integer  "quote_id"
    t.integer  "namedinsured_id"
    t.decimal  "agency_comm_override"
    t.decimal  "producingagency_comm_override"
    t.integer  "originalpolicy_id"
    t.decimal  "cond_comm_producer"
    t.decimal  "cond_comm_generalagency"
    t.integer  "old_id_int"
    t.string   "old_id_txt"
    t.boolean  "is_renewal"
    t.date     "original_expiration_date"
    t.boolean  "is_nonrenew"
    t.boolean  "policy_flag"
    t.string   "flag_note"
    t.datetime "nonrenew_set_date"
    t.boolean  "is_pendingcancellation"
    t.datetime "pendingcancellation_set_date"
  end

  create_table "policypremiumtransactions", :force => true do |t|
    t.decimal  "base_premium"
    t.decimal  "taxes"
    t.decimal  "fees"
    t.decimal  "total_premium"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "policy_id"
    t.string   "transaction_type"
    t.integer  "book_month"
    t.integer  "book_year"
    t.date     "transaction_effective_date"
    t.string   "cash_received"
    t.decimal  "complexfees"
    t.string   "description"
    t.integer  "adjustment_to"
    t.string   "adjusted"
    t.string   "reconciled"
    t.date     "reconciled_date"
    t.integer  "statement_id"
    t.date     "book_date"
    t.integer  "effective_month"
    t.integer  "effective_year"
  end

  create_table "producercommissions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "commission_value"
    t.string   "transaction_type"
    t.integer  "producer_id"
    t.integer  "generalagency_id"
    t.integer  "book_month"
    t.integer  "book_year"
    t.integer  "policy_id"
    t.integer  "policypremiumtransaction_id"
  end

  create_table "producingagencies", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "agency_name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "telephone"
    t.integer  "generalagency_id"
    t.string   "status"
    t.date     "date_appointed"
    t.date     "date_terminated"
    t.string   "agency_code"
    t.string   "agency_contact"
    t.string   "tax_id"
    t.string   "telephone_2"
    t.string   "mailing_address_1"
    t.string   "mailing_address_2"
    t.string   "mailing_city"
    t.string   "mailing_state"
    t.string   "mailing_zip"
    t.string   "main_email"
    t.string   "address_3"
    t.string   "address_4"
    t.string   "name1099"
    t.string   "address1099"
    t.string   "city1099"
    t.string   "state1099"
    t.string   "zip1099"
    t.string   "agency_fax"
    t.string   "main_agent_license"
    t.string   "secondary_emails"
    t.string   "accounting_email",   :limit => 128
  end

  create_table "prospectpolicies", :force => true do |t|
    t.string   "carrier"
    t.date     "expiration_date"
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "client_id"
    t.string   "coverage_type"
  end

  create_table "prospects", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "prospect_name"
    t.integer  "agency_id"
    t.string   "email"
    t.string   "contactname_1"
    t.string   "contactname_2"
    t.string   "contactname_3"
    t.string   "home_phone"
    t.string   "home_phone_2"
    t.string   "cell_phone"
    t.string   "cell_phone_2"
    t.integer  "agent_id"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.text     "comments"
    t.string   "mailing_address_1"
    t.string   "mailing_address_2"
    t.string   "mailing_city"
    t.string   "mailing_state"
    t.string   "mailing_zip"
    t.integer  "location_id"
    t.string   "customer_type"
    t.string   "prospect_status"
    t.string   "referral_source"
  end

  create_table "qualifyinganswers", :force => true do |t|
    t.integer  "qualifyingquestion_id"
    t.integer  "onlinequote_id"
    t.integer  "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "qualifyingquestions", :force => true do |t|
    t.integer  "class_code"
    t.string   "question"
    t.string   "required_answer"
    t.integer  "carrier_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quotes", :force => true do |t|
    t.integer  "agent_id"
    t.integer  "agency_id"
    t.integer  "generalagency_id"
    t.integer  "submission_id"
    t.integer  "client_id"
    t.integer  "carrier_id"
    t.integer  "lobcommission_id"
    t.string   "quotedescription"
    t.integer  "base_premium"
    t.integer  "total_fees"
    t.integer  "total_premium"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lineofbusiness_id"
    t.string   "status"
  end

  create_table "quotingentities", :force => true do |t|
    t.string   "quotingentity_name"
    t.string   "address_1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "telephone"
    t.string   "principal"
    t.date     "signed_up"
    t.string   "license_number"
    t.boolean  "approved"
    t.date     "approved_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "referers", :force => true do |t|
    t.integer  "client_id"
    t.string   "referer_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "agency_id"
  end

  create_table "referrals", :force => true do |t|
    t.integer  "client_id"
    t.integer  "referer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "agency_id"
  end

  create_table "reportingwarehouses", :force => true do |t|
    t.integer  "agency_id"
    t.integer  "generalagency_id"
    t.integer  "book_month"
    t.integer  "book_year"
    t.integer  "new_business_count"
    t.integer  "renewal_count"
    t.integer  "endorsement_count"
    t.integer  "cancellation_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "yearmo"
    t.integer  "policypremiumtransaction_id"
    t.integer  "carrier_id"
    t.integer  "lineofbusiness_id"
    t.integer  "producingagency_id"
    t.integer  "agent_id"
    t.integer  "location_id"
    t.integer  "expired_count"
  end

  create_table "reports", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "return_premium_batches", :force => true do |t|
    t.integer  "generalagency_id"
    t.integer  "agency_id"
    t.decimal  "batch_total"
    t.integer  "transaction_count"
    t.integer  "check_start"
    t.integer  "check_end"
    t.integer  "agent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
  end

  create_table "returnpremiumbatchitems", :force => true do |t|
    t.integer  "policy_id"
    t.integer  "return_premium_batch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cashtransaction_id"
    t.string   "pay_to_entity"
    t.integer  "pfc_id"
    t.integer  "producingagency_id"
    t.integer  "client_id"
  end

  create_table "returnpremiumbatchpreitems", :force => true do |t|
    t.integer  "return_premium_batch_id"
    t.integer  "policy_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "searches", :force => true do |t|
    t.string   "policysearch"
    t.integer  "carrier_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "agency_id"
    t.integer  "generalagency_id"
    t.integer  "agent_id"
  end

  create_table "statementitems", :force => true do |t|
    t.integer  "statement_id"
    t.integer  "policypremiumtransaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "itemamount"
    t.string   "itemprocessedflag"
  end

  create_table "statements", :force => true do |t|
    t.integer  "carrier_id"
    t.integer  "agency_id"
    t.integer  "generalagency_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "agent_id"
    t.decimal  "statement_total"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
  end

  create_table "states", :force => true do |t|
    t.string   "full_name"
    t.string   "abbreviation"
    t.string   "region"
    t.string   "regulatory_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "submission_application_responses", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "submission_applications", :force => true do |t|
    t.string   "field_name"
    t.string   "response"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "submissionposts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "submissionthread_id"
    t.text     "submissionposttext"
    t.integer  "agent_id"
    t.integer  "underwriter_id"
  end

  create_table "submissions", :force => true do |t|
    t.integer  "client_id"
    t.date     "created_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "agency_id"
    t.string   "quotetype"
    t.date     "deadline"
    t.string   "short_note"
    t.integer  "generalagency_id"
    t.integer  "agent_id"
    t.integer  "location_id"
    t.integer  "producingagency_id"
    t.integer  "namedinsured_id"
    t.string   "named_insured"
  end

  create_table "submissionthreads", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "conversation_id"
  end

  create_table "surpluscoveragecodes", :force => true do |t|
    t.string   "coverage_description"
    t.integer  "coverage_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", :force => true do |t|
    t.integer  "policy_id"
    t.integer  "client_id"
    t.text     "task_name"
    t.string   "task_type"
    t.integer  "agent_id"
    t.integer  "agency_id"
    t.date     "completed_on"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "reminder_date"
    t.integer  "submission_id"
    t.integer  "generalagency_id"
    t.integer  "quote_id"
    t.integer  "completed_by"
    t.integer  "mastertask_id"
  end

  create_table "tempdocs", :force => true do |t|
    t.string   "clt_num"
    t.string   "pol_num"
    t.integer  "attach_seq"
    t.string   "file_desc"
    t.string   "file_type"
    t.string   "file_path"
    t.date     "created_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "policy_id"
    t.integer  "quote_id"
    t.string   "s3_path"
    t.string   "file_name"
    t.string   "upload_status"
    t.string   "upload_error"
  end

  create_table "underwriters", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "agency_name"
    t.integer  "quotingentity_id"
  end

  add_index "underwriters", ["email"], :name => "index_underwriters_on_email", :unique => true
  add_index "underwriters", ["reset_password_token"], :name => "index_underwriters_on_reset_password_token", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "agency_name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "workitems", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "workitem_name"
  end

  create_table "worksteps", :force => true do |t|
    t.integer  "workstream_id"
    t.integer  "workitem_id"
    t.integer  "agent_id"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workstreams", :force => true do |t|
    t.integer  "agency_id"
    t.integer  "generalagency_id"
    t.string   "workstream_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "zipcounties", :force => true do |t|
    t.string   "zip"
    t.string   "county_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
