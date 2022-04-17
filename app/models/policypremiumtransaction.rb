class Policypremiumtransaction < ActiveRecord::Base
  before_create :createbookmonthyear
  after_create :accountingprocess, :addtowarehouse
  belongs_to :policy
  has_many :invoices, :dependent => :destroy
  has_many :feetransactions, :dependent => :destroy
  has_many :accountingtransactions, :dependent => :destroy
  has_many :adjustments, :class_name =>"Policypremiumtransaction", :foreign_key => "adjustment_to"
  has_many :statementitem
  has_many :cashtransactions
  has_many :producercommissions


  accepts_nested_attributes_for :invoices, :feetransactions

  attr_accessible :complexfees, :base_premium, :fees, :taxes, :total_premium, :transaction_type, :invoices_attributes,:feetransactions_attributes ,:cash_received, :transaction_effective_date, :description, :endorsetype
  attr_accessor :endorsetype

  def adjusttransaction(details, adjusted_id)

    origppt = Policypremiumtransaction.find(adjusted_id)


    bpadjustment = details[:base_premium].to_f - origppt.adjustmentbasep
    if  !details[:fees].nil?
      feeadjustment = details[:fees].to_f - origppt.adjustmentfees
    else
      feeadjustment = 0
    end
    newppt = Policypremiumtransaction.new
    complexfeeadjustment = 0

    # find diff between existing fees and adjusted ones to create adjustment
    if  !details[:feetransactions_attributes].nil?

      details[:feetransactions_attributes].each_with_index do |ft, index|

        tempcomplexfee = Feetransaction.where("policypremiumtransaction_id = ? AND fee_id = ?", adjusted_id, details[:feetransactions_attributes][index.to_s][:fee_id])


        newcomplexfee = Feetransaction.new

        newcomplexfee.policypremiumtransaction_id = adjusted_id
        newcomplexfee.fee_amount =  (details[:feetransactions_attributes][index.to_s][:fee_amount] - tempcomplexfee[0].fee_amount).round(2)
        newcomplexfee.fee_id = details[:feetransactions_attributes][index.to_s][:fee_id]


        complexfeeadjustment =  complexfeeadjustment + newcomplexfee.fee_amount

        #dont save fee transaction unless there is a difference
        if newcomplexfee.fee_amount != 0
          newcomplexfee.save
        end

      end

      newppt.complexfees = complexfeeadjustment

    end

    origppt.adjusted = "Yes"
    origppt.save


    newppt.base_premium = bpadjustment
    newppt.fees = feeadjustment
    newppt.transaction_type = "Adjust"
    newppt.transaction_effective_date = origppt.transaction_effective_date
    newppt.policy_id = origppt.policy_id
    newppt.adjustment_to = adjusted_id
    newppt.total_premium = bpadjustment + feeadjustment+ complexfeeadjustment
    newppt.save


  end

  def adjustmentbasep
    basep = self.base_premium
    self.adjustments.each do |adj|
      basep = basep + adj.base_premium
    end

    basep
  end
  def adjustmentfees
    begin
      fees = self.fees + self.complexfees
    rescue
      fees = self.complexfees
    end
    self.adjustments.each do |adj|

      if adj.complexfees.nil?
        complex = 0
      else
        complex = adj.complexfees
      end

      fees = fees + adj.fees + complex
    end

    fees
  end
  def adjustmenttotalprem
    tp = self.total_premium
    self.adjustments.each do |adj|
      tp =  tp + adj.total_premium
    end

    tp
  end

  def addtowarehouse

    #dont add adjustments to warehouse
    if self.adjustment_to.blank? then
      dw = Reportingwarehouse.new


      dw.agency_id = self.policy.agency_id
      dw.generalagency_id = self.policy.generalagency_id
      dw.book_year = self.book_year
      dw.book_month = self.book_month

      if self.transaction_type == "New"
        dw.new_business_count = 1
      elsif self.transaction_type == "Renew"
        dw.renewal_count = 1
      elsif self.transaction_type == "Endorse" or self.transaction_type == "Return Premium"
        dw.endorsement_count = 1
      elsif self.transaction_type == "Cancel" or self.transaction_type == "Cancel Pending Statement"
        dw.cancellation_count = 1
      elsif self.transaction_type == "Expire"
        dw.expired_count = 1
      end

      dw.yearmo = self.book_year.to_s + self.book_month.to_s
      dw.policypremiumtransaction_id = self.id
      dw.carrier_id = self.policy.carrier_id
      dw.lineofbusiness_id = self.policy.lineofbusiness_id
      dw.producingagency_id = self.policy.producingagency_id
      dw.agent_id = self.policy.agent_id
      dw.location_id = self.policy.location_id

      dw.save

    end


  end


  def accountingprocess

    @accountingevent = Accountingevent.new

    if self.transaction_type == "New"


      #creating invoice

      Invoice.new.createinvoicenew(self.policy.effective_date, self.total_premium,self.id,self.policy_id )

      @dp = self.invoices.first
      @accountingevent.total_billed = @dp.total_billed
      @accountingevent.transaction_type = self.policy.payment_type_id
      @accountingevent.total_premium = self.total_premium
      @accountingevent.base_premium = self.base_premium
      @accountingevent.fees = self.fees
      @accountingevent.complexfees = self.complexfees

    elsif self.transaction_type == "Adjust"
      #adjustment

      #get adjusted transaction
      adjustedtransaction = Policypremiumtransaction.find(self.adjustment_to)


      @dp = adjustedtransaction.invoices.first

      Invoice.new.adjustinvoice(@dp.id, self.id)

      @accountingevent.total_billed = @dp.total_billed
      @accountingevent.transaction_type = adjustedtransaction.policy.payment_type_id
      @accountingevent.total_premium = self.total_premium
      @accountingevent.base_premium = self.base_premium
      @accountingevent.fees = self.fees
      @accountingevent.complexfees = self.complexfees

    elsif self.transaction_type == "Renew"


      #creating invoice

      Invoice.new.createinvoicenew(self.policy.effective_date, self.total_premium,self.id,self.policy_id )

      @dp = self.invoices.first
      @accountingevent.total_billed = @dp.total_billed
      @accountingevent.transaction_type = self.policy.payment_type_id
      @accountingevent.total_premium = self.total_premium
      @accountingevent.base_premium = self.base_premium
      @accountingevent.fees = self.fees
      @accountingevent.complexfees = self.complexfees

    elsif self.transaction_type == "Endorse"

      @accountingevent.transaction_type = self.policy.payment_type_id
      @accountingevent.total_billed = self.total_premium
      @accountingevent.total_premium = self.total_premium
      @accountingevent.base_premium = self.base_premium
      @accountingevent.complexfees = self.complexfees
      @accountingevent.fees = self.fees
    elsif self.transaction_type == "Flat Cancel"

      #all done

    elsif self.transaction_type == "Cancel"

      @accountingevent.transaction_type = "Cancel"
      @accountingevent.total_premium = self.total_premium
      @accountingevent.cash_received = self.cash_received
      @accountingevent.base_premium = self.base_premium
      @accountingevent.complexfees = self.complexfees
      @accountingevent.fees = self.fees

    elsif self.transaction_type == "Return Premium"
      @accountingevent.transaction_type = "Cancel"
      @accountingevent.total_premium = self.total_premium
      @accountingevent.cash_received = self.cash_received
      @accountingevent.base_premium = self.base_premium
      @accountingevent.complexfees = self.complexfees
      @accountingevent.fees = self.fees

    elsif self.transaction_type =="Reinstate"
      @accountingevent.transaction_type = "Reinstate"
      @accountingevent.total_premium = self.total_premium
      @accountingevent.cash_received = self.cash_received
      @accountingevent.complexfees = self.complexfees

    elsif self.transaction_type == "Cancel Pending Statement"
      @accountingevent.transaction_type = "Cancel Pending Statement"

    end

    if self.transaction_type != 'Flat Cancel'   #flat cancellation handles accounting in policy model
      @accountingevent.line_id = self.policy.lineofbusiness_id
      @accountingevent.state = self.policy.state
      @accountingevent.policy_id = self.policy.id
      @accountingevent.created_date = self.created_at
      @accountingevent.carrier_id = self.policy.carrier_id
      @accountingevent.policypremiumtransaction_id = self.id
      @accountingevent.recordaccountingevent
    end

  end



  def accountingprocessexinv

    @accountingevent = Accountingevent.new

    if self.transaction_type == "New"



      @dp = self.invoices.first
      @accountingevent.total_billed = @dp.total_billed
      @accountingevent.transaction_type = self.policy.payment_type_id
      @accountingevent.total_premium = self.total_premium
      @accountingevent.base_premium = self.base_premium
      @accountingevent.fees = self.fees
      @accountingevent.complexfees = self.complexfees

    elsif self.transaction_type == "Adjust"
      #adjustment

      #get adjusted transaction
      adjustedtransaction = Policypremiumtransaction.find(self.adjustment_to)


      @dp = adjustedtransaction.invoices.first


      @accountingevent.total_billed = @dp.total_billed
      @accountingevent.transaction_type = adjustedtransaction.policy.payment_type_id
      @accountingevent.total_premium = self.total_premium
      @accountingevent.base_premium = self.base_premium
      @accountingevent.fees = self.fees
      @accountingevent.complexfees = self.complexfees

    elsif self.transaction_type == "Renew"


      #creating invoice



      @dp = self.invoices.first
      @accountingevent.total_billed = @dp.total_billed
      @accountingevent.transaction_type = self.policy.payment_type_id
      @accountingevent.total_premium = self.total_premium
      @accountingevent.base_premium = self.base_premium
      @accountingevent.fees = self.fees
      @accountingevent.complexfees = self.complexfees

    elsif self.transaction_type == "Endorse"

      @accountingevent.transaction_type = self.policy.payment_type_id
      @accountingevent.total_billed = self.total_premium
      @accountingevent.total_premium = self.total_premium
      @accountingevent.base_premium = self.base_premium
      @accountingevent.complexfees = self.complexfees
      @accountingevent.fees = self.fees
    elsif self.transaction_type == "Cancel"

      @accountingevent.transaction_type = "Cancel"
      @accountingevent.total_premium = self.total_premium
      @accountingevent.cash_received = self.cash_received
      @accountingevent.base_premium = self.base_premium
      @accountingevent.complexfees = self.complexfees
      @accountingevent.fees = self.fees

    elsif self.transaction_type == "Return Premium"
      @accountingevent.transaction_type = "Cancel"
      @accountingevent.total_premium = self.total_premium
      @accountingevent.cash_received = self.cash_received
      @accountingevent.base_premium = self.base_premium
      @accountingevent.complexfees = self.complexfees
      @accountingevent.fees = self.fees

    elsif self.transaction_type =="Reinstate"
      @accountingevent.transaction_type = "Reinstate"
      @accountingevent.total_premium = self.total_premium
      @accountingevent.cash_received = self.cash_received
      @accountingevent.complexfees = self.complexfees
    end


    @accountingevent.line_id = self.policy.lineofbusiness_id
    @accountingevent.state = self.policy.state
    @accountingevent.policy_id = self.policy.id
    @accountingevent.created_date = self.created_at
    @accountingevent.carrier_id = self.policy.carrier_id
    @accountingevent.policypremiumtransaction_id = self.id
    @accountingevent.recordaccountingevent


  end

  def createbookmonthyear

    now = Date.today

    self.book_month = now.month
    self.book_year =  now.year

    self.book_date = now

  end

  def policiesforchart(agencyid, atype)
    if atype =="Retail"
      @ppts = Policypremiumtransaction.find_by_sql(["SELECT book_month, book_year, transaction_type,Count(policy_id) as pcount FROM policypremiumtransactions ppt INNER JOIN policies pol ON ppt.policy_id = pol.id  GROUP BY ppt.book_month, ppt.book_year, pol.agency_id, ppt.transaction_type HAVING pol.agency_id = ? AND (ppt.transaction_type = 'New' OR ppt.transaction_type = 'Renew') ORDER BY ppt.book_year ASC, ppt.book_month ASC",  agencyid])
    else
      @ppts = Policypremiumtransaction.find_by_sql(["SELECT book_month, book_year, transaction_type, Count(policy_id) as pcount FROM policypremiumtransactions ppt INNER JOIN policies pol ON ppt.policy_id = pol.id  GROUP BY ppt.book_month, ppt.book_year, pol.generalagency_id, ppt.transaction_type HAVING pol.generalagency_id = ? AND (ppt.transaction_type = 'New' OR ppt.transaction_type = 'Renew')  ORDER BY ppt.book_year ASC, ppt.book_month ASC",  agencyid])
    end



  end

  def policylistingreport(agencyid, atype, startdate, enddate)

    if atype =="Retail"
      @ppts = Policypremiumtransaction.find_by_sql(["SELECT ppt.base_premium as base, ppt.fees as fees, ppt.total_premium as total, ppt.transaction_type as transtype, ppt.created_at as createdon ,pol.policy_number as pnum, pol.effective_date as effective_date FROM policypremiumtransactions ppt INNER JOIN policies pol ON ppt.policy_id = pol.id where pol.agency_id =? AND (date_trunc('day',ppt.created_at - interval '5 hours')) >= ? AND (date_trunc('day',ppt.created_at - interval '5 hours')) <= ?", agencyid, startdate, enddate])
    else
      @ppts = Policypremiumtransaction.find_by_sql(["SELECT ppt.base_premium as base, ppt.complexfees as fees, ppt.total_premium as total, ppt.transaction_type as transtype, ppt.created_at as createdon ,pol.policy_number as pnum, pol.effective_date as effective_date FROM policypremiumtransactions ppt INNER JOIN policies pol ON ppt.policy_id = pol.id where pol.generalagency_id =? AND (date_trunc('day',ppt.created_at - interval '5 hours')) >= ? AND (date_trunc('day',ppt.created_at - interval '5 hours')) <= ?", agencyid, startdate, enddate])
    end

  end


  #used to pull transactions for statement reconcillation
  def reconciliationtransactions(agencyid, atype, startdate, enddate, carrier_id)
    carrier = Carrier.find(carrier_id)
    if atype =="Retail"


      if carrier.isstatementgroup?

        @ppts = Policypremiumtransaction.order("policies.policy_number ASC").joins(:policy).where("policies.agency_id=? AND policies.carrier_id IN (?) AND policypremiumtransactions.transaction_effective_date >= ? AND policypremiumtransactions.transaction_effective_date <= ? AND policypremiumtransactions.reconciled is null", agencyid, carrier.statementgroupmembers,  startdate, enddate)

      else
        @ppts = Policypremiumtransaction.order("policies.policy_number ASC").joins(:policy).where("policies.agency_id=?  AND policies.carrier_id=? AND policypremiumtransactions.transaction_effective_date >= ? AND policypremiumtransactions.transaction_effective_date <= ? AND policypremiumtransactions.reconciled is null", agencyid, carrier_id,  startdate, enddate)
      end
    else
      if carrier.isstatementgroup?
        @ppts = Policypremiumtransaction.order("policies.policy_number ASC").joins(:policy).where("policies.generalagency_id=? AND policies.carrier_id IN (?) AND policypremiumtransactions.transaction_effective_date >= ? AND policypremiumtransactions.transaction_effective_date <= ? AND policypremiumtransactions.reconciled is null", agencyid, carrier.statementgroupmembers, startdate, enddate)
      else
        @ppts = Policypremiumtransaction.order("policies.policy_number ASC").joins(:policy).where("policies.generalagency_id=? AND policies.carrier_id=? AND policypremiumtransactions.transaction_effective_date >= ? AND policypremiumtransactions.transaction_effective_date <= ? AND policypremiumtransactions.reconciled is null", agencyid, carrier_id, startdate, enddate)
      end
    end
    @ppts
  end

  #used to pull all unreconciled transactions for statement reconcillation
  def unreconciliedtransactions(agencyid, atype, carrier_id)

    if atype =="Retail"

      @ppts = Policypremiumtransaction.order("id ASC").joins(:policy).where("policies.agency_id=?  AND policypremiumtransactions.reconciled is null", agencyid)
    else
      @ppts = Policypremiumtransaction.order("id ASC").joins(:policy).where("policies.generalagency_id=? AND policies.carrier_id=? AND policypremiumtransactions.reconciled is null", agencyid, carrier_id)
    end
    @ppts
  end

  def processreconciliation(ppt_ids,  statement_id)



    ppt_ids.each do |ppt|
      if !ppt[:cancelpending].nil?
        # if the cancellation details are entered, we need to run the accountingtransactions for them
        # before reconciling.
        cancppt = Policypremiumtransaction.find(ppt[:ppt_id])
        cancppt.base_premium = (ppt[:cancelpending][0][:commissionable].to_i) * -1
        cancppt.fees = (ppt[:cancelpending][0][:noncommissionable].to_i) * -1
        cancppt.total_premium = ((ppt[:cancelpending][0][:commissionable].to_i) +  (ppt[:cancelpending][0][:noncommissionable].to_i)) *-1
        cancppt.transaction_type ="Cancel"
        cancppt.save

        cancppt.accountingprocess

      end
      reconcile(ppt[:ppt_id], statement_id)
    end


  end

  def reconcile(ppt_id, statement_id)
    ppt = Policypremiumtransaction.find(ppt_id)
    policy = Policy.find(ppt.policy_id)

    # NEW, REINSTATE, ENDORSE OR RENEW SECTION
    ###########################################
    if ppt.transaction_type == "New" or ppt.transaction_type == "Endorse" or ppt.transaction_type == "Reinstate" or ppt.transaction_type == "Renew"

      if policy.payment_type_id == 5 #direct bill
        commissionamount = ppt.pptreconciliationcommission


        if policy.status == "Active" or policy.status == "Renewed"  or policy.status == "Expired" or policy.status == "Cancelled"
          if ppt.transaction_type == "Reinstate" and  policy.accountbalance(10003, 'Asset') == 0

          else
            @accountingtransactions = Accountingtransaction.new
            @accountingtransactions.account_id = 10003
            @accountingtransactions.policy_id = ppt.policy_id
            @accountingtransactions.trans_type = 'Credit'
            @accountingtransactions.amount = commissionamount
            @accountingtransactions.policypremiumtransaction_id = ppt.id
            @accountingtransactions.reconcile_flag = 'Yes'
            @accountingtransactions.save

          end
        end

        @accountingtransactions = Accountingtransaction.new
        @accountingtransactions.account_id = 20002
        @accountingtransactions.policy_id = ppt.policy_id
        @accountingtransactions.trans_type = 'Debit'
        @accountingtransactions.amount = commissionamount
        @accountingtransactions.policypremiumtransaction_id = ppt.id
        @accountingtransactions.reconcile_flag = 'Yes'
        @accountingtransactions.save


        @accountingtransactions = Accountingtransaction.new
        @accountingtransactions.account_id = 10001
        @accountingtransactions.policy_id = ppt.policy_id
        @accountingtransactions.trans_type = 'Debit'
        @accountingtransactions.amount = commissionamount
        @accountingtransactions.policypremiumtransaction_id = ppt.id
        @accountingtransactions.reconcile_flag = 'Yes'
        @accountingtransactions.save


        @accountingtransactions = Accountingtransaction.new
        @accountingtransactions.account_id = 30001
        @accountingtransactions.policy_id = ppt.policy_id
        @accountingtransactions.trans_type = 'Credit'
        @accountingtransactions.amount = commissionamount
        @accountingtransactions.policypremiumtransaction_id = ppt.id
        @accountingtransactions.reconcile_flag = 'Yes'
        @accountingtransactions.save
      elsif policy.payment_type_id == 1 #agency bill - net HERE WE ARE CONCERNED WITH PREMIUM DUE VS COMMISSION
        prempayrec = ppt.prempayrec

        Accountingevent.new.acct_recordtransaction(ppt.policy_id,20001,'Debit',prempayrec,ppt.id,'Yes','')


        @accountingtransactions = Accountingtransaction.new
        @accountingtransactions.account_id = 10001
        @accountingtransactions.policy_id = ppt.policy_id
        @accountingtransactions.trans_type = 'Credit'
        @accountingtransactions.amount = prempayrec
        @accountingtransactions.policypremiumtransaction_id = ppt.id
        @accountingtransactions.reconcile_flag = 'Yes'
        @accountingtransactions.save


      end
      # CANCELLATION & RETURN PREMIUM TRANSACTION SECTION
      ####################################################
    elsif ppt.transaction_type == "Cancel" or ppt.transaction_type == "Return Premium"
      # AGENCY BILL - NET
      if policy.payment_type_id == 1
        prempayrec = ppt.prempayrec



        @accountingtransactions = Accountingtransaction.new
        @accountingtransactions.account_id = 10001
        @accountingtransactions.policy_id = ppt.policy_id
        @accountingtransactions.trans_type = 'Debit'
        @accountingtransactions.amount = prempayrec
        @accountingtransactions.policypremiumtransaction_id = ppt.id
        @accountingtransactions.reconcile_flag = 'Yes'
        @accountingtransactions.save


        Accountingevent.new.acct_recordtransaction(ppt.policy_id,10005,'Credit',prempayrec,ppt.id,'Yes', '')


        # DIRECT BILL
      elsif policy.payment_type_id == 5


        reonciliationcommission = ppt.pptreconciliationcommission * -1

        @accountingtransactions = Accountingtransaction.new
        @accountingtransactions.account_id = 10001
        @accountingtransactions.policy_id = ppt.policy_id
        @accountingtransactions.trans_type = 'Credit'
        @accountingtransactions.amount =  reonciliationcommission
        @accountingtransactions.policypremiumtransaction_id = ppt.id
        @accountingtransactions.reconcile_flag = 'Yes'
        @accountingtransactions.save

        #20007 is commission payable
        #if policy.accountbalance(20002, 'Liability') > 0
        # if (ppt.pptreconciliationcommission * -1) >  policy.accountbalance(20002, 'Liability')
        @accountingtransactions = Accountingtransaction.new
        @accountingtransactions.account_id = 20007
        @accountingtransactions.policy_id = ppt.policy_id
        @accountingtransactions.trans_type = 'Debit'
        @accountingtransactions.amount = reonciliationcommission #policy.accountbalance(20002, 'Liability')
        @accountingtransactions.policypremiumtransaction_id = ppt.id
        @accountingtransactions.reconcile_flag = 'Yes'
        @accountingtransactions.save

        #20002 is unearned commission
        @accountingtransactions = Accountingtransaction.new
        @accountingtransactions.account_id = 20002
        @accountingtransactions.policy_id = ppt.policy_id
        @accountingtransactions.trans_type = 'Credit'
        @accountingtransactions.amount = reonciliationcommission #policy.accountbalance(20002, 'Liability')
        @accountingtransactions.policypremiumtransaction_id = ppt.id
        @accountingtransactions.reconcile_flag = 'Yes'
        @accountingtransactions.save

=begin
        @accountingtransactions = Accountingtransaction.new
        @accountingtransactions.account_id = 10003
        @accountingtransactions.policy_id = ppt.policy_id
        @accountingtransactions.trans_type = 'Credit'
        @accountingtransactions.amount = reonciliationcommission
        @accountingtransactions.policypremiumtransaction_id = ppt.id
        @accountingtransactions.reconcile_flag = 'Yes'
        @accountingtransactions.save
=end

        @accountingtransactions = Accountingtransaction.new
        @accountingtransactions.account_id = 30001
        @accountingtransactions.policy_id = ppt.policy_id
        @accountingtransactions.trans_type = 'Debit'
        @accountingtransactions.amount = reonciliationcommission
        @accountingtransactions.policypremiumtransaction_id = ppt.id
        @accountingtransactions.reconcile_flag = 'Yes'
        @accountingtransactions.save


=begin
      else
        @accountingtransactions = Accountingtransaction.new
        @accountingtransactions.account_id = 20007
        @accountingtransactions.policy_id = ppt.policy_id
        @accountingtransactions.trans_type = 'Debit'
        @accountingtransactions.amount = (ppt.pptreconciliationcommission * -1)
        @accountingtransactions.policypremiumtransaction_id = ppt.id
        @accountingtransactions.reconcile_flag = 'Yes'
        @accountingtransactions.save

      end
    else
      #10003 is commission receivable
      if policy.accountbalance(10003, 'Asset') != 0
        @accountingtransactions = Accountingtransaction.new
        @accountingtransactions.account_id = 10003
        @accountingtransactions.policy_id = ppt.policy_id
        @accountingtransactions.trans_type = 'Credit'
        @accountingtransactions.amount = (ppt.pptreconciliationcommission * -1)
        @accountingtransactions.policypremiumtransaction_id = ppt.id
        @accountingtransactions.reconcile_flag = 'Yes'
        @accountingtransactions.save
      end
    end

  else
=end
  end
end
ppt.reconciled = "Yes"
if statement_id != 'Single'
  ppt.statement_id = statement_id
end

ppt.save

end
=begin
def paramsclean(pptparams)

## Used to remove $ sign and commas from values
# cancellations are negative since money is being returned to the policy
pptparams[:total_premium] = ((pptparams[:total_premium]).gsub( /[^\d.]/,'').to_f) * -1
pptparams[:base_premium] = ((pptparams[:base_premium]).gsub( /[^\d.]/,'').to_f) * -1



if !pptparams[:complexfees].nil?
pptparams[:complexfees] =  ((pptparams[:complexfees]).gsub( /[^\d.]/,'').to_f ) * -1
else
pptparams[:fees] = ((pptparams[:fees]).gsub( /[^\d.]/,'').to_f)  * -1
end
begin
# if there are complex fees, it goes through each one
pptparams[:feetransactions_attributes].each_with_index do |a, index|
#need to multiply by -1 because these fees are being returned
pptparams[:feetransactions_attributes][index.to_s][:fee_amount] = -1* (pptparams[:feetransactions_attributes][index.to_s][:fee_amount]).gsub( /[^\d.]/,'').to_f

end
rescue

end

pptparams
end

=end
def paramsclean(pptparams, negative)

  puts "PPTPARAMS"
  puts pptparams
  puts negative

  if negative
    multiplier = -1
  else
    multiplier = 1
  end

  ## Used to remove $ sign and commas from values
  # cancellations are negative since money is being returned to the policy
  pptparams[:total_premium] = ((pptparams[:total_premium]).gsub( /[^\d.]/,'').to_f)  * multiplier

  pptparams[:base_premium] = ((pptparams[:base_premium]).gsub( /[^\d.]/,'').to_f)  * multiplier



  if !pptparams[:complexfees].nil?
    pptparams[:complexfees] =  ((pptparams[:complexfees]).gsub( /[^\d.]/,'').to_f )* multiplier
  else
    pptparams[:fees] = ((pptparams[:fees]).gsub( /[^\d.]/,'').to_f)  * multiplier
  end
  begin
    # if there are complex fees, it goes through each one
    pptparams[:feetransactions_attributes].each_with_index do |a, index|
      #need to multiply by -1 because these fees are being returned
      pptparams[:feetransactions_attributes][index.to_s][:fee_amount] =  multiplier * (pptparams[:feetransactions_attributes][index.to_s][:fee_amount]).gsub( /[^\d.]/,'').to_f

    end
  rescue

  end

  pptparams
end

#sums all the commission for a ppt
def pptcommission
  accttrans = Accountingtransaction.where("account_id = 30001").find_all_by_policypremiumtransaction_id(self.id)
  commission = 0
  accttrans.each do |acct|
    tempval = 0
    if acct.trans_type == 'Credit'
      tempval = acct.amount
    else
      tempval = acct.amount * -1
    end
    commission = commission + tempval
  end

  commission
end


#sums all the unearned commission for a ppt
def pptunearnedcommission
  accttrans = Accountingtransaction.where("account_id = 20002").find_all_by_policypremiumtransaction_id(self.id)
  commission = 0
  accttrans.each do |acct|
    tempval = 0
    if acct.trans_type == 'Credit'
      tempval = acct.amount
    else
      tempval = acct.amount * -1
    end
    commission = commission + tempval
  end

  commission
end


def pptreconciliationcommission
  if self.policy.payment_type_id == 5
    self.pptunearnedcommission + self.pptcommission
  else
    self.pptcommission
  end
end

#sums the net premium payable and receivable for a ppt
def prempayrec
  payable = Accountingtransaction.where("account_id = 20001").find_all_by_policypremiumtransaction_id(self.id)
  receivable = Accountingtransaction.where("account_id = 10005").find_all_by_policypremiumtransaction_id(self.id)
  total = 0
  payable.each do |acct|
    tempval = 0
    if acct.trans_type == 'Credit'
      tempval = acct.amount
    else
      tempval = acct.amount * -1
    end
    total = total+ tempval
  end
  receivable.each do |acct|
    tempval = 0
    if acct.trans_type == 'Credit'
      tempval = acct.amount * -1
    else
      tempval = acct.amount
    end
    total = total+ tempval
  end

  if total < 0
    total = total * -1
  end
  total
end

#shows a friendlier net premium payable and receivable negative for payable positive for receivable
def prempayrecfriendly
  payable = Accountingtransaction.where("account_id = 20001").find_all_by_policypremiumtransaction_id(self.id)
  receivable = Accountingtransaction.where("account_id = 10005").find_all_by_policypremiumtransaction_id(self.id)
  total = 0
  paytotal = 0
  rectotal = 0

  payable.each do |acct|
    tempval = 0
    if acct.trans_type == 'Credit'
      tempval = acct.amount
    else
      tempval = acct.amount * -1
    end
    paytotal = paytotal+ tempval
  end

  receivable.each do |acct|
    tempval = 0
    if acct.trans_type == 'Credit'
      tempval = acct.amount * -1
    else
      tempval = acct.amount
    end
    rectotal = rectotal + tempval
  end

  total = rectotal - paytotal
end

def pptcommissionproducer
  accttrans = Accountingtransaction.where("account_id = 40001").find_all_by_policypremiumtransaction_id(self.id)


  commission = 0
  accttrans.each do |acct|
    tempval = 0
    if acct.trans_type == 'Credit'
      tempval = acct.amount
    else
      tempval = acct.amount * -1
    end
    commission = commission + tempval
  end


  if self.adjusted  == 'Yes'
    self.adjustments.each do |adj|

      adjaccttrans = Accountingtransaction.where("account_id = 40001").find_all_by_policypremiumtransaction_id(adj.id)
      adjaccttrans.each do |ajt|
        tempval = 0
        if ajt.trans_type == 'Credit'
          tempval = ajt.amount
        else
          tempval = ajt.amount * -1
        end
        commission = commission + tempval
      end


    end


  end

  commission
end


def feetotal
  if self.transaction_type == "Cancel" ||  self.transaction_type == "Return Premium"
    transmod = -1
  else
    transmod = 1
  end
  if !self.complexfees.nil?
    feetotal = self.complexfees * transmod
  elsif !self.fees.nil?
    feetotal = self.fees * transmod
  else
    feetotal = 0
  end
end


def surpluslinesreport( startdate, enddate, agency_id )
  @pollist = Policy.
      joins("
          JOIN carriers c ON policies.carrier_id = c.id AND c.admitted_status = 'Non Admitted'
          ").
      where("
          policies.generalagency_id = ?
          AND policies.id IN (
            SELECT policy_id FROM policypremiumtransactions WHERE created_at >= ? AND created_at <= ? AND base_premium != 0
          )
          AND policies.id NOT IN ( 123494, 123724 )", agency_id, startdate, enddate )
end


def surpluslinespolicytransaction( startdate, enddate, policy )
  pptlist = []
  pptbeforecancel = []
  pptbackout = []
  cancel = nil
  backout = false

  t = Policypremiumtransaction.where("
        policy_id = ?
        AND created_at <= ?
        AND base_premium != 0", policy.id, enddate ).
      order("policypremiumtransactions.created_at DESC")

  t.each do | ppt |
    # regular transaction sequence
    if cancel.nil? && backout == false
      if ppt.created_at < startdate && ( ppt.created_at > Date.new( 2018,9,20 ) || ppt.transaction_type != 'Cancel' )
        if ['Cancel','Flat Cancel','Cancel Pending Statement'].include? ppt.transaction_type && pptlist.count > 0
          if ppt.transaction_effective_date > policy.effective_date
            pptlist[0].transaction_type = 'Reinstate'
          else
            pptlist[0].transaction_type = 'New'
          end
        end
        break
      end
      unless ['Cancel','Flat Cancel','Cancel Pending Statement'].include? ppt.transaction_type
        pptlist.unshift ppt
      else
        if ppt.transaction_effective_date > policy.effective_date
          if pptlist.count == 0
            cancel = ppt
            ppt.transaction_type = 'Cancel'
            pptlist.unshift ppt
          else
            pptlist.shift
          end
        else
          backout = true
          if pptlist.count > 0
            pptlist[0].transaction_type = 'New'
          end
        end
      end

    # after Cancel transaction found
    elsif !cancel.nil? && backout == false
      if ppt.created_at < startdate && ( ppt.created_at > Date.new( 2018,9,20 ) || ppt.transaction_type != 'Cancel' )
        if ['Cancel','Flat Cancel','Cancel Pending Statement'].include? ppt.transaction_type && pptbeforecancel.count > 0
          if ppt.transaction_effective_date > policy.effective_date
            pptbeforecancel[0].transaction_type = 'Reinstate'
          else
            pptbeforecancel[0].transaction_type = 'New'
          end
        end
        pptlist = pptbeforecancel + pptlist
        break
      end
      unless ['Cancel','Flat Cancel','Cancel Pending Statement'].include? ppt.transaction_type
        pptbeforecancel.unshift ppt
      else
        if ppt.transaction_effective_date > policy.effective_date
          if pptbeforecancel.count == 0
            ppt.transaction_type = 'Cancel'
            pptbeforecancel.unshift ppt
          else
            pptbeforecancel.shift
          end
        else
          backout = true
          if pptbeforecancel.count > 0
            pptbeforecancel[0].transaction_type = 'New'
          end
        end
      end

    # after Backout transaction found regardless of Cancel transaction
    else
      if ppt.created_at < startdate && ( ppt.created_at > Date.new( 2018,9,20 ) || ppt.transaction_type != 'Cancel' )
        if ['Cancel','Flat Cancel','Cancel Pending Statement'].include? ppt.transaction_type
          if ppt.transaction_effective_date > policy.effective_date
            if pptbackout.count == 0
              break # should never get here - it can't be cancel transaction and immediately after it flat cancel transaction...
            else
              pptbackout.pop
            end
          else
            if pptbackout.count > 0
              pptbackout.last.transaction_type = 'Backout New'
            end
            break
          end
        else
          ppt.transaction_type = 'Backout ' + ppt.transaction_type
          ppt.base_premium = -ppt.base_premium
          pptbackout.push ppt
        end
      end
    end
  end
  pptlist = pptbackout + pptbeforecancel + pptlist
  pptlist
end


def surpluslinestransactiontype
  if self.transaction_type == "New"
    @transtype = 1
    #treat adjustments like endorsements
  elsif self.transaction_type == "Endorse" || self.transaction_type == "Adjust"
    # override for GIC which treats return premium endorsements like return premium
    if self.total_premium < 0 then
      # if return premium, dont classify as endorsement
      @transtype = 3
    else
      @transtype = 2
    end
  elsif self.transaction_type == "Return Premium"
    @transtype = 3
  elsif self.transaction_type == "Cancel"
    @transtype = 4
  elsif self.transaction_type == "Renew"
    @transtype = 5
  elsif self.transaction_type == "Reinstate"
    @transtype = 14
  elsif self.transaction_type == "Backout New"
    @transtype = 11
    #treat adjustments like endorsements
  elsif self.transaction_type == "Backout Endorse" || self.transaction_type == "Backout Adjust"
    # override for GIC which treats return premium endorsements like return premium
    if self.total_premium < 0 then
      # if return premium, dont classify as endorsement
      @transtype = 13
    else
      @transtype = 12
    end
  elsif self.transaction_type == "Backout Return Premium"
    @transtype = 13
  elsif self.transaction_type == "Backout Renew"
    @transtype = 15
  end

  @transtype
end


def transactioneffective
  if [ "New", "Renew" ].include? self.transaction_type
    @eff = self.policy.effective_date
  else
    @eff = self.transaction_effective_date
  end
end


def revenuefees
  @revenuefees = Feetransaction.find_all_by_policypremiumtransaction_id(self.id)
  @total = 0
  @revenuefees.each do |fee|
    if fee.fee.fee_remit_type == "Revenue"
      @total = @total + fee.fee_amount
    end
  end

  if self.transaction_type.start_with? 'Backout'
    @total = -@total
  end

  @total
end


def gadirectbillrecoprocess(policy_id, recoamount)
  policy = Policy.find(policy_id)
  carrier = Carrier.find(policy.carrier_id)
  carrierlob = Carrierlob.where("carrier_id =? AND lineofbusiness_id =?", carrier.id,policy.lineofbusiness_id)

  commission = Lobcommission.where("carrierlob_id =? AND state = ?", carrierlob[0].id, policy.state)

  if policy.cond_comm_producer == nil
    prodcomm = commission[0].producer_rate
  else
    prodcomm =  policy.cond_comm_producer
  end

  amttoproducer = (( prodcomm/ commission[0].commission_rate) * recoamount.to_f).round(2)

  if recoamount.to_f < 0
    recoamount = recoamount.to_f * -1
    amttoproducer = amttoproducer * -1
    # cash
    @accountingtransactions = Accountingtransaction.new
    @accountingtransactions.account_id = 10001
    @accountingtransactions.policy_id = policy.id
    @accountingtransactions.trans_type = 'Credit'
    @accountingtransactions.amount = recoamount.to_f
    @accountingtransactions.reconcile_flag = 'Yes'
    @accountingtransactions.save

    #commission receivable from producer
    accountingevent = Accountingevent.new

    accountingevent.acct_recordtransaction(policy.id , 20005, 'Debit', amttoproducer.to_f, 'none', 'Yes', '')

    #commission payable to producer
    ## need to add condition to make it debit to comm rec from producer
    #accountingevent = Accountingevent.new
    #accountingevent.acct_recordtransaction(policy.id, 20005, 'Debit', amttoproducer, 'none', 'Yes', '')

    #commission revenue
    @accountingtransactions = Accountingtransaction.new
    @accountingtransactions.account_id = 30001
    @accountingtransactions.policy_id = policy.id
    @accountingtransactions.trans_type = 'Debit'
    @accountingtransactions.amount = recoamount.to_f
    @accountingtransactions.reconcile_flag = 'Yes'
    @accountingtransactions.save

    #commission payable to producer
    @accountingtransactions = Accountingtransaction.new
    @accountingtransactions.account_id = 40001
    @accountingtransactions.policy_id = policy.id
    @accountingtransactions.trans_type = 'Credit'
    @accountingtransactions.amount = amttoproducer
    @accountingtransactions.reconcile_flag = 'Yes'
    @accountingtransactions.save
  else
    # cash
    @accountingtransactions = Accountingtransaction.new
    @accountingtransactions.account_id = 10001
    @accountingtransactions.policy_id = policy.id
    @accountingtransactions.trans_type = 'Debit'
    @accountingtransactions.amount = recoamount.to_f
    @accountingtransactions.reconcile_flag = 'Yes'
    @accountingtransactions.save

    #commission receivable
    @accountingtransactions = Accountingtransaction.new
    @accountingtransactions.account_id = 10003
    @accountingtransactions.policy_id = policy.id
    @accountingtransactions.trans_type = 'Credit'
    @accountingtransactions.amount = recoamount.to_f
    @accountingtransactions.reconcile_flag = 'Yes'
    @accountingtransactions.save

    #commission payable to producer
    @accountingtransactions = Accountingtransaction.new
    @accountingtransactions.account_id = 20005
    @accountingtransactions.policy_id = policy.id
    @accountingtransactions.trans_type = 'Credit'
    @accountingtransactions.amount = amttoproducer
    @accountingtransactions.reconcile_flag = 'Yes'
    @accountingtransactions.save

    #unearned commission
    @accountingtransactions = Accountingtransaction.new
    @accountingtransactions.account_id = 20002
    @accountingtransactions.policy_id = policy.id
    @accountingtransactions.trans_type = 'Debit'
    @accountingtransactions.amount = recoamount.to_f
    @accountingtransactions.reconcile_flag = 'Yes'
    @accountingtransactions.save

    #commission revenue
    @accountingtransactions = Accountingtransaction.new
    @accountingtransactions.account_id = 30001
    @accountingtransactions.policy_id = policy.id
    @accountingtransactions.trans_type = 'Credit'
    @accountingtransactions.amount = recoamount.to_f
    @accountingtransactions.reconcile_flag = 'Yes'
    @accountingtransactions.save

    #commission payable to producer
    @accountingtransactions = Accountingtransaction.new
    @accountingtransactions.account_id = 40001
    @accountingtransactions.policy_id = policy.id
    @accountingtransactions.trans_type = 'Debit'
    @accountingtransactions.amount = amttoproducer
    @accountingtransactions.reconcile_flag = 'Yes'
    @accountingtransactions.save
  end
end


def updatecommission(newrate, oldrate)
  a = Accountingevent.new
  if newrate.to_f > oldrate.to_f
    newcommamnt = (self.base_premium * (newrate.to_f - oldrate.to_f)).round(2)
    @accountingtransactions = Accountingtransaction.new
    @accountingtransactions.account_id = 40001
    @accountingtransactions.policypremiumtransaction_id = self.id
    @accountingtransactions.policy_id = policy.id
    @accountingtransactions.trans_type = 'Debit'
    @accountingtransactions.amount = newcommamnt
    @accountingtransactions.save

    a.acct_recordtransaction(self.policy_id, 10006, "Credit", newcommamnt, self.id, false, false)

    self.invoices.each do |i|
      unless i.total_billed.nil?
        i.total_billed = i.total_billed - newcommamnt
        i.save
      end
    end

  else
    newcommamnt = (self.base_premium * ( oldrate.to_f - newrate.to_f)).round(2)
    @accountingtransactions = Accountingtransaction.new
    @accountingtransactions.account_id = 40001
    @accountingtransactions.policypremiumtransaction_id = self.id
    @accountingtransactions.policy_id = policy.id
    @accountingtransactions.trans_type = 'Credit'
    @accountingtransactions.amount = newcommamnt
    @accountingtransactions.save

    a.acct_recordtransaction(self.policy_id, 10006, "Debit", newcommamnt, self.id, false, false)

    self.invoices.each do |i|
      i.total_billed = i.total_billed + newcommamnt
      i.save
    end
  end



end


end
