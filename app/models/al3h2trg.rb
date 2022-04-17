class Al3h2trg < ActiveRecord::Base
  belongs_to :al3file
  has_one :al3transaction
  has_one :al3h5bis
  has_one :al3h9bis
  has_one :al3h5bpi
  has_many :al3h5ptss

  def process(algroup, agency_id)
    al2trg = Al3h2trg.new
    al2trg.header = algroup[0..9]
    al2trg.transaction_structure_standard_vers_number = algroup[10..11]
    al2trg.application_software_revision_level = algroup[12..19]
    al2trg.transaction_image = algroup[20..20]
    al2trg.automation_level = algroup[21..21]
    al2trg.transaction_category = algroup[22..23]
    al2trg.policy_type_routing_code = algroup[24..24]
    al2trg.line_of_business_routing_code = algroup[25..29]
    al2trg.transaction_function = algroup[30..32]
    al2trg.processing_cycle_status = algroup[33..33]
    al2trg.initial_transaction_mode = algroup[34..34]
    al2trg.special_response_option = algroup[35..35]
    al2trg.error_processing_option = algroup[36..36]
    al2trg.formal_transaction_address_sender = algroup[37..46]
    al2trg.informal_transaction_address_sender = algroup[47..71]
    al2trg.formal_transaction_address_recipient = algroup[72..81]
    al2trg.informal_transaction_address_recipient = algroup[82..106]
    al2trg.special_handling = algroup[107..116]
    al2trg.origination_reference_information = algroup[117..141]
    al2trg.transaction_sequence_number = algroup[142..145]
    al2trg.processing_cycle_number = algroup[152..155]
    al2trg.reference_transaction_sequence_number = algroup[156..159]
    al2trg.response_automation_level = algroup[166..166]
    al2trg.cycle_business_purpose = algroup[167..169]
    al2trg.synchronation_field = algroup[170..179]
    al2trg.segment_level_code = algroup[180..180]
    al2trg.segmented_transaction_counter = algroup[181..183]
    al2trg.segmented_transaction_total_pieces = algroup[184..186]
    al2trg.quote_date = algroup[187..194]
    ## accomodating date differences between older versions of 2trg
    if  algroup[146..151].size > 0
       trans_date = algroup[146..151]
       trans_date = "20" + trans_date

      puts trans_date
    else
       trans_date = algroup[196..203]
    end
    al2trg.transaction_date = trans_date
    al2trg.transaction_effective_date = algroup[204..211]
    al2trg.save

    trans = Al3transaction.new
    trans.agency_id = agency_id
    trans.transaction_date = al2trg.transaction_date
    trans.transaction_function = al2trg.transaction_function
    trans.cycle_business_purpose = al2trg.cycle_business_purpose
    trans.transaction_effective_date = al2trg.transaction_effective_date
    trans.al3h2trg_id = al2trg.id
    trans.processed = false
    trans.save

    al2trg.id
  end

end
