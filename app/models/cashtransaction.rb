class Cashtransaction < ActiveRecord::Base
  before_save :createbookmonthyear
  belongs_to :invoice
  belongs_to :policy
  belongs_to :return_premium_batch
  belongs_to :returnpremiumbatchitem
  belongs_to :compay_batch
  belongs_to :compaybatchitem
  belongs_to :producingagency
  belongs_to :pfc
  belongs_to :policypremiumtransaction
  attr_accessible :cash_amount, :check_number, :transaction_effective_date, :policy_id

  def createbookmonthyear

    now = Date.today

    self.book_month = now.month
    self.book_year =  now.year

    self.book_date = now
  end


  def accountingtransaction
    @ppt = Policypremiumtransaction.new

    @accountingevent = Accountingevent.new
    @accountingevent.transaction_type = 'Cash'
    @accountingevent.total_premium = self.cash_amount

    @accountingevent.policy_id =  $policyforcancel
    @accountingevent.invoice_id = self.invoice_id
    @accountingevent.created_date = self.created_at
    @accountingevent.cashtransactions_id = self.id
    @accountingevent.recordaccountingevent
  end

  def paycarrier
    @accountingevent = Accountingevent.new
    @accountingevent.transaction_type = 'Carrier Payment'
    @accountingevent.total_premium = self.cash_amount

    @accountingevent.policy_id =  $policyforcancel
    @accountingevent.invoice_id = self.invoice_id
    @accountingevent.created_date = self.created_at

    @accountingevent.recordaccountingevent
  end



  #apply cashtransactions for commission payable
  def compaywork(cashamount, policyid, batchid, checknum, producingagency_id , direction)
    if cashamount != 0


      #cash transaction
      @cashtransaction = Cashtransaction.new
      @cashtransaction.cash_amount = cashamount


      @cashtransaction.transaction_type = "Commission Payable"

      @cashtransaction.policy_id = policyid


      @cashtransaction.producingagency_id = producingagency_id




      @cashtransaction.check_number = checknum
      @cashtransaction.compaybatchitem_id = batchid
      @cashtransaction.save

      if direction == "outward"
      @accountingevent = Accountingevent.new
      @accountingevent.transaction_type = 'Commission Payable'
      @accountingevent.total_premium = cashamount
      @accountingevent.cashtransactions_id = @cashtransaction.id
      @accountingevent.policy_id =  policyid

      @accountingevent.created_date = @cashtransaction.created_at

      @accountingevent.recordaccountingevent
      end

      if direction == "inward"
        @accountingevent = Accountingevent.new
        @accountingevent.transaction_type = 'Commission Receivable'
        @accountingevent.total_premium = cashamount
        @accountingevent.cashtransactions_id = @cashtransaction.id
        @accountingevent.policy_id =  policyid

        @accountingevent.created_date = @cashtransaction.created_at

        @accountingevent.recordaccountingevent
      end

    end
  end


  #used in return premium functionality
  def applyreturn(cashamount, paymenttype, cascade, agentid,  polid, batchid, checknum, producingagency_id, pfc_id)


    @thispolicy = Policy.find(polid)

=begin
    if cascade == "yes"

      @pptforview = Policypremiumtransaction.find_all_by_policy_id(@thispolicy.id)


      @invoicesforcascade = Invoice.find_all_by_policypremiumtransaction_id(@pptforview , :order => "id asc")


      tempcash = cashamount


      @invoicesforcascade.each do |inv|

        if tempcash < 0
          if tempcash < inv.outstandingbalance
            returnwork(inv.id,inv.outstandingbalance,paymenttype,@thispolicy.id, @thispolicy.carrier_id, agentid, batchid, checknum, producingagency_id, pfc_id)
          else
            returnwork(inv.id,tempcash,paymenttype,@thispolicy.id, @thispolicy.carrier_id, agentid, batchid, checknum, producingagency_id, pfc_id)
          end
        end
        tempcash =  tempcash - inv.outstandingbalance
      end


    else
=end
    #apply to last invoice


    ppt = Policypremiumtransaction.where("transaction_type <> 'Reinstate' and transaction_type <>'Adjust'").find_all_by_policy_id(@thispolicy.id).last
    invoice = Invoice.find_all_by_policypremiumtransaction_id(ppt).last

    returnwork(invoice.id,cashamount,paymenttype,@thispolicy.id, @thispolicy.carrier_id, agentid, batchid, checknum, producingagency_id, pfc_id)
    #end


  end

  #creates a cashtransaction for the invoice to reduce the negative balance
  #creates an accountingevent to debit premium payable and credit cash
  def returnwork(invoice, cashamount, paymenttype, policyid, carrierid, agentid, batchid, checknum, producingagency_id, pfc_id)



    if cashamount != 0



      #cash transaction
      @cashtransaction = Cashtransaction.new
      @cashtransaction.cash_amount = cashamount
      @cashtransaction.invoice_id =invoice

      @cashtransaction.transaction_type = "Return Premium"
      @cashtransaction.agent_id = agentid
      @cashtransaction.policy_id = policyid

      if !producingagency_id.nil?
        @cashtransaction.producingagency_id = producingagency_id
      elsif !pfc_id.nil?
        @cashtransaction.pfc_id = pfc_id
      end



      @cashtransaction.check_number = checknum
      @cashtransaction.returnpremiumbatchitem_id = batchid
      @cashtransaction.save


      @accountingevent = Accountingevent.new
      @accountingevent.transaction_type = 'Return'
      @accountingevent.total_premium = (@cashtransaction.cash_amount * -1)
      @accountingevent.cashtransactions_id = @cashtransaction.id
      @accountingevent.policy_id =  policyid
      @accountingevent.invoice_id = invoice
      @accountingevent.created_date = @cashtransaction.created_at
      @accountingevent.carrier_id = carrierid
      @accountingevent.recordaccountingevent
    end

  end



  #decides how the payment will be applied, if cascading then payment is applied from oldest to newest invoice
  def applypayment(invoice, cashamount, cascade, agentid, checknumber, effectivedate, transferflag)


    @thispolicy = Policy.all :joins=>{:policypremiumtransactions => :invoices}, :conditions => {'invoices.id'=>invoice}


    if cascade == "yes"

      @pptforview = Policypremiumtransaction.find_all_by_policy_id(@thispolicy[0].id)


      @invoicesforcascade = Invoice.find_all_by_policypremiumtransaction_id(@pptforview , :order => "id asc")

      puts @invoicesforcascade

      if @thispolicy[0].arbalance  < cashamount
        tempcash = @thispolicy[0].arbalance
        overpaymentamt = cashamount - tempcash
      else
        tempcash = cashamount
        overpaymentamt = 0
      end


      @invoicesforcascade.each do |inv|

        if tempcash > 0
          if tempcash > inv.outstandingbalance
            paymentwork(inv.id,inv.outstandingbalance,@thispolicy[0].id, @thispolicy[0].carrier_id, agentid, checknumber, effectivedate, transferflag)
          else
            paymentwork(inv.id,tempcash,@thispolicy[0].id, @thispolicy[0].carrier_id, agentid, checknumber, effectivedate, transferflag)
          end
        end
        tempcash =  tempcash - inv.outstandingbalance
      end

      #apply the overpayment after you have applied the cash
      if overpaymentamt > 0
        @accountingevent = Accountingevent.new
        @accountingevent.transaction_type = 'Cash'
        @accountingevent.total_premium = overpaymentamt

        @accountingevent.policy_id =  @thispolicy[0].id
        @accountingevent.created_date = Date.today

        @accountingevent.carrier_id = @thispolicy[0].carrier_id
        @accountingevent.recordaccountingevent

      end



    else
      paymentwork(invoice,cashamount,@thispolicy[0].id, @thispolicy[0].carrier_id, agentid, checknumber, effectivedate, transferflag)
    end
  end

  #actually does the work of entering the payment
  def paymentwork(invoice, cashamount, policyid, carrierid, agentid, checknumber, effectivedate, transferflag)

    @cashtransaction = Cashtransaction.new
    @cashtransaction.cash_amount = cashamount
    @cashtransaction.invoice_id =invoice
    if transferflag == 'yes'
      @cashtransaction.transfer_flag = transferflag
    end
    @cashtransaction.transaction_type = "Policyholder Payment"
    @cashtransaction.agent_id = agentid
    @cashtransaction.policy_id = policyid
    @cashtransaction.check_number = checknumber
    @cashtransaction.transaction_effective_date = effectivedate
    @cashtransaction.save

    @cashtransactions = Cashtransaction.find_all_by_invoice_id(invoice)
    @accountingevent = Accountingevent.new
    @accountingevent.transaction_type = 'Cash'
    @accountingevent.total_premium = @cashtransaction.cash_amount
    @accountingevent.cashtransactions_id = @cashtransaction.id
    @accountingevent.policy_id =  policyid
    @accountingevent.invoice_id = Invoice.find(invoice).id.to_s
    @accountingevent.created_date = @cashtransaction.created_at

    @accountingevent.carrier_id = carrierid
    @accountingevent.recordaccountingevent

  end

  def reversecash(type, *transto)

    @nsftrans = Accountingtransaction.find_all_by_cashtransaction_id(self.id)
    @cashtransnsf = Cashtransaction.find(self.id)
    if type =="nsf"
      @cashtransnsf.nsf_flag = "yes"

    elsif type == "void"
      @cashtransnsf.void_flag = "yes"
    end


    @cashtransnsf.save

    self.save
    @nsftrans.each do |nsf|
      @accountingtransactions = Accountingtransaction.new
      @accountingtransactions.policy_id = self.policy_id
      @accountingtransactions.account_id = nsf.account_id
      @accountingtransactions.amount =  nsf.amount

      if nsf.trans_type == 'Credit'
        @accountingtransactions.trans_type = 'Debit'
      else

        @accountingtransactions.trans_type = 'Credit'

      end

      @accountingtransactions.save
    end



    @nsfcash = Cashtransaction.new

    @nsfcash.invoice_id = self.invoice_id

    @nsfcash.cash_amount = self.cash_amount * -1
    if type == "nsf"

      @nsfcash.transaction_type = "Returned / NSF"
      @nsfcash.check_number =  "Returned / NSF"
    elsif type =="transfer"

      @nsfcash.transaction_type = "Transferred to policy # " +transto[0].to_s
      @nsfcash.check_number = "Transfer"
    else

      @nsfcash.transaction_type = "Void"
      @nsfcash.check_number = "Void"
    end
    @nsfcash.policy_id = self.policy_id


    @nsfcash.save


  end


  def cashreport(agency, startdate, enddate)

    @cash = Cashtransaction.find_by_sql(["SELECT inv.id as invoiceid, ct.id as ctid, ct.cash_amount, ct.created_at as created_at FROM cashtransactions ct INNER JOIN invoices inv ON ct.invoice_id = inv.id WHERE inv.generalagency_id = ? AND ct.created_at between ? and ? ORDER BY ct.created_at ASC", agency, startdate ,enddate ])

  end

  def searchinvoice(search)
    @invoices = Invoice.find_by_sql(["SELECT inv.id as invoiceid FROM invoices inv WHERE inv.total_billed LIKE ?",search ])
  end


  def policieswithreturn( agency, startdate = Date.new( 2017, 01, 01 ), enddate = DateTime.now ) 
    #aa@policies = Policy.find_all_by_generalagency_id( agency )
    #puts startdate
    #puts enddate
    #puts Policy.where( generalagency_id: agency ).where(effective_date: startdate..enddate ).to_sql
    @policies = Policy.where( generalagency_id: agency ).where(effective_date: startdate..enddate ).order(:id)

    @polreturn = []

    @policies.each do |pol|
#      if pol.id == 121340 then puts '!!' end
#      if pol.id == 121340 then puts pol.policybalancefixtest end
      if pol.policybalancefixtest < 0 then
        @polreturn << pol
      end
    end

    @polreturn
  end


  def policieswithreturncount(agency)
    cnt = 0
    policies = Policy.find_all_by_generalagency_id(agency)


    policies.each do |pol|
      if pol.policybalance < 0 then
        cnt = cnt + 1
      end
    end
    cnt
  end

  def policieswithcompay(agency)

    @policies = Policy.find_all_by_generalagency_id(agency)


    @polcompay = []

    @policies.each do |pol|

      if pol.accountbalance(20005, 'Liability')> 0 then
        @polcompay << pol
      end
      if pol.accountbalance(10004, 'Asset')> 0 then
        @polcompay << pol
      end

    end

    @polcompay
  end


  def policieswithcompaycount(agency)
    cnt = 0
    policies = Policy.find_all_by_generalagency_id(agency)

    policies.each do |pol|
      if pol.accountbalance(20005, 'Liability')> 0 then
        cnt = cnt + 1
      end
      if pol.accountbalance(10004, 'Asset')> 0 then
        cnt = cnt + 1
      end
    end
    cnt
  end


  def processunearnedcommissionpayment
    accountingevent = Accountingevent.new

    accountingevent.acct_recordtransaction(self.policy_id , 10004, 'Credit', self.cash_amount, 'none', 'Yes', '')
    accountingevent.acct_ind_trans(self.policy_id, 10001, 'Debit', self.cash_amount, 'none', 'Yes')
  end


  def outstandinginvoice
    begin
      @invoices = Invoice.find_by_sql(["SELECT invoice_id AS invoiceid FROM cashtransactions WHERE transaction_type = 'Applied to Invoice Balance' AND policypremiumtransaction_id  = ?", self.policypremiumtransaction_id])
      @invoices.first.invoiceid
    rescue
    end
  end
end
