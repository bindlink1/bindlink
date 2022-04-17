class Report < ActiveRecord::Base
  def agingreport(agencyid, agegroupstart, agegroupend, atype)
#puts '------'
#i = 0
#k = 0
#t = Time.now
    maxAgeGroupEnd = ( Time.now.to_date - Date.parse('01-01-2017') ).to_i
    if agegroupend > maxAgeGroupEnd then agegroupend = maxAgeGroupEnd end
#puts agegroupend
    @allinvoice = Invoice.joins(:policypremiumtransaction => :policy).joins("LEFT JOIN ( SELECT invoice_id, SUM( cash_amount) AS amt FROM cashtransactions GROUP BY invoice_id ) as t ON invoices.id = t.invoice_id ").where("policies.generalagency_id = :agencyid AND COALESCE( total_billed, 0) > COALESCE( amt, 0 ) AND due_on > NOW()::date - :agegroupend AND due_on <= NOW()::date - :agegroupstart ",  {agencyid: agencyid, agegroupstart: agegroupstart, agegroupend: agegroupend} ).order( "due_on desc" )
#puts Time.now - t
    @output = []

    @allinvoice.each do |inv|
      begin
#        i += 1
        #if inv.is_paid == "Not Paid"
          #if inv.invoiceage >= agegroupstart && inv.invoiceage <= agegroupend
            #j+=1
            if inv.policypremiumtransaction.policy.policybalance >= 0.01 && inv.policypremiumtransaction.policy.payment_type_id != 5
#              k+=1
              @output << inv
            end
          #end
        #end
      rescue
      end
    end
#puts i
#puts j
#puts k
#puts Time.now - t
    @output
  end


  def expiringreport(agencyid,startdate, enddate, atype, lobid, carrierid )
    @expiring = Policy.where( "expiration_date >= ? AND expiration_date <= ?", startdate, enddate ).
      where( "#{ atype == "Retail" ? "" : "general" }agency_id = ?", agencyid ).
      order( "expiration_date asc")
    unless lobid == "all"
      @expiring = @expiring.where( "lineofbusiness_id = ?", lobid )
    end
    unless carrierid == "all"
      @expiring = @expiring.where( "carrier_id = ?", carrierid )
    end
    @expiring
  end


  def renewalreport( startdate, enddate, lobid )
    r = Policy.where( "expiration_date >= ? AND expiration_date <= ? AND generalagency_id = 1 AND status = 'Active'", startdate, enddate ).
        where( "id NOT IN ( SELECT policy_id FROM documents WHERE ( name LIKE 'Renewal Offer%' OR name LIKE 'Non-Renewal%' ) AND policy_id IS NOT NULL )" ).
        order("expiration_date")
    if lobid != "all"
      r = r.where( "lineofbusiness_id = ?", lobid )
    end
    r
  end


  def incomesummary(agencyid, startdate, enddate, atype, carrierid, datetype)
    if atype == "Retail"
      if carrierid == "all"
        if datetype =="effective"
          @countnew = Policypremiumtransaction.joins(:policy).where("policypremiumtransaction.transaction_effective_date >= ? AND policypremiumtransaction.transaction_effective_date <= ? AND policy.agency_id = ? AND policypremiumtransaction.transaction_type = 'New'", startdate, enddate, agencyid).count()
        else
          @countnew = Policypremiumtransaction.joins(:policy).where("policypremiumtransaction.book_date >= ? AND policypremiumtransaction.book_date <= ? AND policy.agency_id = ? AND policypremiumtransaction.transaction_type = 'New'", startdate, enddate, agencyid).count()
        end

      else
        if datetype =="effective"
          @countnew = Policypremiumtransaction.joins(:policy).where("policypremiumtransaction.transaction_effective_date >= ? AND policypremiumtransaction.transaction_effective_date <= ? AND policy.agency_id = ? AND policypremiumtransaction.transaction_type = 'New' AND policy.carrier_id = ?", startdate, enddate, agencyid, carrierid).count()
        else
          @countnew = Policypremiumtransaction.joins(:policy).where("policypremiumtransaction.book_date >= ? AND policypremiumtransaction.book_date <= ? AND policy.agency_id = ? AND policypremiumtransaction.transaction_type = 'New' AND policy.carrier_id = ?", startdate, enddate, agencyid, carrierid).count()
        end
      end
    end
  end


  def agingreportcount(agencyid, agegroupstart, agegroupend)

    @allinvoice = Invoice.order("due_on asc").find_all_by_generalagency_id(agencyid)
    @output = 0


    @allinvoice.each do |inv|

      if inv.is_paid == "Not Paid"
        if inv.invoiceage >= agegroupstart && inv.invoiceage <=agegroupend
          @output = @output + inv.outstandingbalance
        end
      end

    end

    @output

  end



end
