task :populatereportingwarehouse => :environment do

  Reportingwarehouse.delete_all

  #select time dimension
  ppts = Policypremiumtransaction.all


      #select("policies.agency_id, policies.generalagency_id, policypremiumtransactions.book_year, policypremiumtransactions.book_month").joins("JOIN policies ON policies.id = policypremiumtransactions.policy_id").group("policies.agency_id, policies.generalagency_id, policypremiumtransactions.book_year, policypremiumtransactions.book_month")


  #populate time dimension
  ppts.each do |ppt|
   begin
    dw = Reportingwarehouse.new


    dw.agency_id = ppt.policy.agency_id
    dw.generalagency_id = ppt.policy.generalagency_id
    dw.book_year = ppt.book_year
    dw.book_month = ppt.book_month

    if ppt.transaction_type == "New"
      dw.new_business_count = 1
    elsif ppt.transaction_type == "Renew"
      dw.renewal_count = 1
    elsif ppt.transaction_type == "Endorse" or ppt.transaction_type == "Return Premium"
      dw.endorsement_count = 1
    elsif ppt.transaction_type == "Cancel"
      dw.cancellation_count = 1
    elsif ppt.transaction_type == "Expire"
      dw.expired_count = 1
    end

    dw.yearmo = ppt.book_year.to_s + ppt.book_month.to_s
    dw.policypremiumtransaction_id = ppt.id
    dw.carrier_id = ppt.policy.carrier_id
    dw.lineofbusiness_id = ppt.policy.lineofbusiness_id
    dw.producingagency_id = ppt.policy.producingagency_id
    dw.agent_id = ppt.policy.agent_id
    dw.location_id = ppt.policy.location_id

    dw.save
   rescue
   end

  end


end