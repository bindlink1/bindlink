class Policy < ActiveRecord::Base

  belongs_to :agency
  belongs_to :generalagency
  belongs_to :producingagency
  belongs_to :client
  belongs_to :carrier
  belongs_to :pfc
  belongs_to :lineofbusiness
  belongs_to :carrierlob
  has_many :policypremiumtransactions , :dependent => :destroy
  has_many :invoices, :through => :policypremiumtransactions
  has_many :feetransactions, :through => :policypremiumtransactions
  has_many :cashtransactions
  has_one :location
  belongs_to :namedinsured
  belongs_to :quote
  has_many :tasks , :dependent => :destroy
  has_many :notes , :dependent => :destroy
  has_many :inboundemails , :dependent => :destroy
  has_one :acord_xml_pers_auto_policy , :dependent => :destroy
  has_one :homeownerpolicy, :dependent => :destroy
  has_many :returnpremiumbatchitems
  has_many :accountingtransactions, :dependent => :destroy
  has_one :homeownerpolicy
  has_many :al3transactions
  has_many :documents
  accepts_nested_attributes_for :policypremiumtransactions, :namedinsured

  attr_accessible :policy_number, :client_id ,:policy_term, :carrier_id, :effective_date, :mga_id, :expiration_date, :lineofbusiness_id, :payment_type_id, :coverage_id, :description,:policy_type, :policypremiumtransactions_attributes,  :pfc_id, :pfc_contract, :pfc_date_due, :state, :named_insured, :producingagency_id, :quote_id, :namedinsured_id, :originalpolicy_id, :namedinsured_attributes, :cond_comm_producer, :cond_comm_generalagency, :is_renewal, :policy_flag, :flag_note
  attr_accessor :fullname, :policybalance

  def fullname
    self.client.fullname
  end


  def documentcount
    Document.new.policydoccount(self.id)
  end


  def endorsementcount
    Document.new.policyendorsecount(self.id)
  end


  def claimcount
    Document.new.policyclaimcount(self.id)
  end


  def outstandingtaskcount
    count = Task.where("status is null  AND mastertask_id is null AND policy_id = ?", self.id).count()

  end

  def completedtaskcount
    count = Task.where("status = 'completed'  AND mastertask_id is null AND policy_id = ?", self.id).count()
  end

  def producercommrate
    #get line of business for carrier and commission
    carrierlob = Carrierlob.where("carrier_id =? AND lineofbusiness_id =?", self.carrier_id,self.lineofbusiness_id )
    commission = Lobcommission.where("carrierlob_id =? AND state = ?", carrierlob[0].id, self.state )

    if self.cond_comm_producer == nil
      commission[0].producer_rate
    else
      self.cond_comm_producer
    end

  end

  #Charting Methods
  def policycount(agentid)

    @agent = Agent.find(agentid)


    if @agent.isgeneralagent == "GA"

      @count = Policy.find_all_by_generalagency_id(@agent.generalagency_id).count()
    else

      @count = Policy.find_all_by_agency_id(@agent.agency_id).count()
    end
  end
  #End charting methods


  def cancelcount
    @cancelcount = self.policypremiumtransactions.where(:transaction_type => 'Cancel').count
  end


  def nsfcount
    @nsfcount = self.cashtransactions.where(:transaction_type => 'Returned / NSF').count
  end


  def isga

    if self.generalagency_id.blank?
      @isga ="Retail"
    else
      @isga = "GA"
    end

    @isga
  end


  def self.policyrenewalbyperiodcount( i, type )
    count = self.policyrenewalbyperiod( i, type ).count
  end


  def self.policytypecondition( type )
    condition = "
        ( is_nonrenew = 'f' OR is_nonrenew IS NULL )
        AND policies.status = 'Active'
        AND payment_type_id IN ( ? )
      "
    pol = Policy.where( condition, type == "Direct" ? 5..8 : 1..4 )
  end


  def self.policyrenewalbyperiod( i, type )
    dateperiod =   "now()::date      AND now()::date +  5"
    if i == 6
      dateperiod = "now()::date +  6 AND now()::date + 15"
    elsif i == 16
      dateperiod = "now()::date + 16 AND now()::date + 25"
    elsif i == 26
      dateperiod = "now()::date + 26 AND now()::date + 60"
    end
    condition = "
        expiration_date BETWEEN " + dateperiod + "
      "

    pol = self.policytypecondition( type ).where( condition )
    #puts pol.to_sql
    #pol
  end


  def policybalance

    @bal = Invoice.all :joins=>{:policypremiumtransaction => :policy}, :conditions=>{'policies.id'=>self.id}

    @outstanding = 0
    begin
      @bal.each do |inv|

        @outstanding = @outstanding+ inv.outstandingbalance
      end
    rescue
    end
    @outstanding
  end


  def policybalancefixtest
    #invoices are joined on policypremiumtransactions, loop through all of the policy's ppts
    outstanding = 0
    self.policypremiumtransactions.each do |ppt|
      #if self.id == 121340 then puts '-----' end
      #if self.id == 121340 then puts ppt.id end
      if ppt.invoices.count > 0
        ppt.invoices.each do |inv|
          #if self.id == 121340 then puts '===' end
          #if self.id == 121340 then puts inv.id end
          #if self.id == 121340 then puts inv.outstandingbalance end
          begin
            outstanding = outstanding + inv.outstandingbalance
          rescue
            
          end
        end
      end
    end
    return outstanding
  end


  def accountbalance(account, type)
    #get all cash transactions
    @accttrans = Accountingtransaction.find_all_by_policy_id(self.id)

    @balance = 0

    @accttrans.each do |acct|
      if acct.account_id == account

        if acct.trans_type =='Credit'
          if type =='Asset'
            @tempamount  = acct.amount * -1
          else
            @tempamount =  acct.amount
          end
        else
          if type =='Asset'
            @tempamount = acct.amount
          else
            @tempamount  = acct.amount * -1
          end
        end

        @balance = @balance + @tempamount
      end
    end

    @balance
  end








  def cashbalance
    #get all cash transactions
    @premiumpayabletrans = Accountingtransaction.find_all_by_policy_id(self.id)

    @balance = 0

    @premiumpayabletrans.each do |ppt|
      if ppt.account_id == 10001

        if ppt.trans_type =='Credit'
          @tempamount  = ppt.amount * -1
        else
          @tempamount = ppt.amount
        end

        @balance = @balance + @tempamount
      end
    end

    @balance
  end

  def cashtransactions
    @cashtrans = Accountingtransaction.find_all_by_policy_id(self.id)

  end

  def premiumreceivablefromph
    #get all 10002 transactions
    @premiumpayabletrans = Accountingtransaction.find_all_by_policy_id(self.id)

    @balance = 0

    @premiumpayabletrans.each do |ppt|
      if ppt.account_id == 10002

        if ppt.trans_type =='Credit'
          @tempamount  = ppt.amount * -1
        else
          @tempamount = ppt.amount
        end

        @balance = @balance + @tempamount
      end
    end

    @balance
  end

  def commissionreceivable
    #get all 10003 transactions
    @premiumpayabletrans = Accountingtransaction.find_all_by_policy_id(self.id)

    @balance = 0

    @premiumpayabletrans.each do |ppt|
      if ppt.account_id == 10003

        if ppt.trans_type =='Credit'
          @tempamount  = ppt.amount * -1
        else
          @tempamount = ppt.amount
        end

        @balance = @balance + @tempamount
      end
    end

    @balance
  end

  def premiumfinancereceivable
    #get all 10004 transactions
    @premiumpayabletrans = Accountingtransaction.find_all_by_policy_id(self.id)

    @balance = 0

    @premiumpayabletrans.each do |ppt|
      if ppt.account_id == 10004

        if ppt.trans_type =='Credit'
          @tempamount  = ppt.amount * -1
        else
          @tempamount = ppt.amount
        end

        @balance = @balance + @tempamount
      end
    end

    @balance
  end

  def apbalance
    #get all premium payable transactions
    @premiumpayabletrans = Accountingtransaction.find_all_by_policy_id(self.id)

    @balance = 0

    @premiumpayabletrans.each do |ppt|
      if ppt.account_id == 20001 || ppt.account_id ==  20004

        if ppt.trans_type =='Credit'
          @tempamount  = ppt.amount
        else
          @tempamount = ppt.amount * -1
        end

        @balance = @balance + @tempamount
      end
    end

    @balance
  end

  def apbalancetoph
    #get all premium payable transactions
    @premiumpayabletrans = Accountingtransaction.find_all_by_policy_id(self.id)

    @balance = 0

    @premiumpayabletrans.each do |ppt|
      if ppt.account_id ==  20004

        if ppt.trans_type =='Credit'
          @tempamount  = ppt.amount
        else
          @tempamount = ppt.amount * -1
        end

        @balance = @balance + @tempamount
      end
    end

    @balance
  end

  def prempayabletocarrier
    #get all premium payable transactions
    @premiumpayabletrans = Accountingtransaction.find_all_by_policy_id(self.id)

    @balance = 0

    @premiumpayabletrans.each do |ppt|
      if ppt.account_id ==  20001

        if ppt.trans_type =='Credit'
          @tempamount  = ppt.amount
        else
          @tempamount = ppt.amount * -1
        end

        @balance = @balance + @tempamount
      end
    end

    @balance
  end

  def carrierbalance
    dueto = self.accountbalance(20001, 'Liability')
    duefrom = self.accountbalance(10005, 'Asset')

    dueto - duefrom
  end

  def feepayable
    #get all payable fees
    @feepayabletrans = Accountingtransaction.find_all_by_policy_id(self.id)

    @balance = 0
    @tempamount = 0
    @feepayabletrans.each do |ppt|
      if ppt.account_id ==  20003

        if ppt.trans_type =='Credit'
          @tempamount  = ppt.amount
        else
          @tempamount = ppt.amount * -1
        end

        @balance = @balance + @tempamount
      end
    end

    @balance
  end



  def unearnedcommission
    #get all premium payable transactions
    @premiumpayabletrans = Accountingtransaction.find_all_by_policy_id(self.id)

    @balance = 0

    @premiumpayabletrans.each do |ppt|
      if ppt.account_id ==  20002

        if ppt.trans_type =='Credit'
          @tempamount  = ppt.amount
        else
          @tempamount = ppt.amount * -1
        end

        @balance = @balance + @tempamount
      end
    end

    @balance
  end

  def arbalance
    #get all premium receivable transactions
    @premiumreceivabletrans = Accountingtransaction.find_all_by_policy_id(self.id)

    @balance = 0


    @balance = self.accountbalance(10006, 'Asset')  + self.accountbalance(10002, 'Asset')
  end




  def arbalancecarrier
    #get all premium receivable transactions
    @premiumreceivabletrans = Accountingtransaction.find_all_by_policy_id(self.id)

    @balance = 0

    @premiumreceivabletrans.each do |ppt|
      if ppt.account_id == 10005

        if ppt.trans_type =='Credit'
          @tempamount  = ppt.amount * -1
        else
          @tempamount = ppt.amount
        end

        @balance = @balance + @tempamount
      end
    end

    @balance
  end

  def assetstotal
    @balance = 0
    @balance = self.cashbalance + self.premiumreceivablefromph + self.commissionreceivable + self.premiumfinancereceivable + self.arbalancecarrier + self.accountbalance(10006, 'Asset')  + self.accountbalance(10007, 'Asset')
    @balance
  end

  def liabilitytotal
    @balance = 0
    @balance = self.prempayabletocarrier + self.unearnedcommission + self.apbalancetoph + self.feepayable + self.accountbalance(20005, 'Liability') + self.accountbalance(20006, 'Liability') + self.accountbalance(20007, 'Liability') + self.accountbalance(30001, 'OE') + self.accountbalance(30002, 'OE') + self.accountbalance(40001, 'OE')
    @balance
  end

  def accounting_balance
    balance = self.assetstotal - self.liabilitytotal

    balance
  end

  def totalpolicypremium
    @premiumtransactions = Policypremiumtransaction.find_all_by_policy_id(self.id)
    @temppremium = 0

    @premiumtransactions.each do |ppt|
      if ppt.transaction_type == 'New'
        @temppremium = @temppremium + ppt.total_premium

      end

    end

    @temppremium

  end

  #used in the api for policeis
  def policypremiumsum
    @premiumtransactions = Policypremiumtransaction.find_all_by_policy_id(self.id)
    @temppremium = 0

    @premiumtransactions.each do |ppt|
      if ppt.transaction_type == 'New' || ppt.transaction_type == 'Renew'
        @temppremium = @temppremium + ppt.total_premium

      end

    end

    @temppremium

  end

  def commissionrate
    carrierlob = Carrierlob.where("carrier_id =? AND lineofbusiness_id =?", self.carrier_id,self.lineofbusiness_id )
    commission = Lobcommission.where("carrierlob_id =? AND state = ?", carrierlob[0].id, self.state )


    if self.is_renewal?
      if !self.agency_id.blank?
        if  !commission[0].commission_rate_renew.blank?
          commission[0].commission_rate_renew
        else
          commission[0].commission_rate
        end

      else
        commission[0].commission_rate
      end

    else
      commission[0].commission_rate
    end

  end

###POLICY TRANSACTIONS###
############################################################################################

  def bindpolicy(agent_id)
    carrierlob = Carrierlob.where("carrier_id =? AND lineofbusiness_id =?", self.carrier_id,self.lineofbusiness_id )
    commission = Lobcommission.where("carrierlob_id =? AND state = ?", carrierlob[0].id, self.state )

    if self.payment_type_id.blank? || self.payment_type_id == "0"
      self.payment_type_id = commission[0].billing_type
    end

    agent = Agent.find(agent_id)

    if agent.isgeneralagent == "Retail"
      self.agency_id = agent.agency_id
      #if this is a prospect converting to client
      self.client.convertprospect
    else
      self.generalagency_id = agent.generalagency_id

      #if this is a policy created from a quote we set the policies named insured to be the same as the quotes, not creating a new one
      if !self.quote_id.nil?

        quote = Quote.find(self.quote_id)

        quote.bindquote

        self.namedinsured_id = quote.submission.namedinsured_id
      else
        self.namedinsured.generalagency_id = agent.generalagency_id
        self.namedinsured.producingagency_id = self.producingagency_id
      end
    end

    #indicates policy initiated by namedinsured
    if  !self.namedinsured_id.nil?
      nitemp = Namedinsured.find(self.namedinsured_id)
      #@policy.namedinsured_id = nitemp.id
      self.producingagency_id = nitemp.producingagency.id
    end

    #since this is a new policy, I am setting it to active
    self.status = "Active"

    # Note: accounting transactions are being recorded in policypremiumtransactions model since this is a
    #nested model form

    self.save
  end


  def endorse(endorse_params)


    if endorse_params[:endorsetype] == "Return"
      endorse_params =  Policypremiumtransaction.new.paramsclean(endorse_params,true)

      endorseppt = Policypremiumtransaction.new(endorse_params)
      endorseppt.transaction_type = "Return Premium"
    else
      endorse_params =  Policypremiumtransaction.new.paramsclean(endorse_params, false)

      endorseppt = Policypremiumtransaction.new(endorse_params)
      endorseppt.transaction_type = "Endorse"
    end

    #this is here to translate the date format used in the application to the format
    #used in the DB
    effdate = Date.new
    effdate = Date.strptime(endorse_params[:transaction_effective_date].to_s, '%m/%d/%Y')
    endorseppt.transaction_effective_date = effdate
    endorseppt.policy_id = self.id
    endorseppt.save



    carrierlob = Carrierlob.where("carrier_id =? AND lineofbusiness_id =?", self.carrier_id,self.lineofbusiness_id )

    commission = Lobcommission.where("carrierlob_id =? AND state = ?", carrierlob[0].id, self.state )


    invoice = Invoice.new

    if !commission[0].producer_rate.nil?
      # if there is a rate for producers, then deduct it from the invoice and if there are complexfees
      # calculate the commission net of the complex fees
      if !endorse_params[:complexfees].blank?
        complex = endorse_params[:complexfees]


        if endorseppt.transaction_type == "Return Premium"
          invoice.createinvoice(endorseppt.transaction_effective_date, (endorseppt.total_premium + (((-1* endorseppt.total_premium)+ complex)*commission[0].producer_rate)) , endorseppt.id)
        else
          invoice.createinvoice(endorseppt.transaction_effective_date, (endorseppt.total_premium - ((( endorseppt.total_premium) - complex)*commission[0].producer_rate)) , endorseppt.id)
        end
      else
        if endorseppt.transaction_type == "Return Premium"
          invoice.createinvoice(endorseppt.transaction_effective_date, (endorseppt.total_premium + ((-1* endorseppt.total_premium)*commission[0].producer_rate)) , endorseppt.id)
        else
          invoice.createinvoice(endorseppt.transaction_effective_date, (endorseppt.total_premium - (( endorseppt.total_premium)*commission[0].producer_rate)) , endorseppt.id)
        end
      end
    else
      invoice.createinvoice(endorseppt.transaction_effective_date, endorseppt.total_premium , endorseppt.id)

    end

    if endorseppt.transaction_type == "Return Premium"
      if self.arbalance != 0
        self.cancellationtoinvoice(endorseppt.total_premium  , endorseppt.base_premium, endorseppt.complexfees, endorseppt.id)
      end
    end
  end

  def flatcancel
    if (5..8).include? self.payment_type_id
      self.cancelsimple nil
      return
    end
    #create flat cancel ppt

    flatppc = Policypremiumtransaction.new
    flatppc.transaction_type = "Flat Cancel"
    flatppc.policy_id = self.id
    flatppc.transaction_effective_date = self.effective_date
    flatppc.save

    ppt = Policypremiumtransaction.find_all_by_policy_id(self.id)
    totalbase = 0
    totalfees = 0
    ppt.each do |p|

      if p.transaction_type != "Flat Cancel"
        #accounting transactions

        p.accountingtransactions.each do |a|
          # exclude fees - they get handled below

          if a.account_id != 30002 and a.account_id != 20003 and a.account_id != 10006 and a.account_id != 10001

            @accountingtransactions = Accountingtransaction.new
            @accountingtransactions.policy_id = self.id
            @accountingtransactions.account_id = a.account_id

            #reverse transaction type

            if a.trans_type == 'Credit'
              tt = 'Debit'
            else
              tt = 'Credit'
            end

            @accountingtransactions.trans_type = tt
            @accountingtransactions.amount = a.amount
            @accountingtransactions.policypremiumtransaction_id = flatppc.id
            @accountingtransactions.save
       end


      end


        #fee reversal
        p.feetransactions.each do |f|
          @feetransaction = Feetransaction.new
          @feetransaction.policypremiumtransaction_id = flatppc.id
          @feetransaction.fee_amount = f.fee_amount * -1
          @feetransaction.fee_id = f.fee_id
          @feetransaction.save
          totalfees = totalfees + f.fee_amount
        end

      end

      begin
        totalbase = totalbase + p.base_premium
      rescue

      end

      p.save
    end
    flatppc.base_premium = totalbase * -1
    flatppc.fees = totalfees * -1
    flatppc.complexfees = totalfees * -1
    flatppc.total_premium = (totalbase * -1) + (totalfees * -1)

    flatppc.save
    ######################################
    #************create invoice
    ######################################


    #get line of business for carrier and commission
    carrierlob = Carrierlob.where("carrier_id =? AND lineofbusiness_id =?", self.carrier_id,self.lineofbusiness_id )
    commission = Lobcommission.where("carrierlob_id =? AND state = ?", carrierlob[0].id, self.state )


    ######################################
    #************create invoice

    invoice = Invoice.new

    if !commission[0].producer_rate.nil?

      # if there is a rate for producers, then deduct it from the invoice and if there are complexfees
      # calculate the commission net of the complex fees


      if !flatppc.fees.nil?

        complex = flatppc.fees

        invoice.createinvoice(flatppc.transaction_effective_date, (flatppc.total_premium + (((-1* flatppc.total_premium) + complex)*commission[0].producer_rate)) , flatppc.id)
      else
        invoice.createinvoice(flatppc.transaction_effective_date, (flatppc.total_premium + ((-1* flatppc.total_premium)*commission[0].producer_rate)) , flatppc.id)
      end
    else

      invoice.createinvoice(flatppc.transaction_effective_date, flatppc.total_premium , flatppc.id)

    end

    #************end create invoice
    self.cancellationtoinvoice(flatppc.total_premium, flatppc.base_premium, flatppc.fees, flatppc.id)



    #************end create invoice
    self.status = "Cancelled"
    self.save
  end



  def cancel(canc_params, money_received)
    #removing $ sign and commas from parameters as well as modifying values for cancellation
    #all values are positive numbers when coming in as parameters
    #paramscleancancel transforms them into negatives
    canc_params =  Policypremiumtransaction.new.paramsclean(canc_params, true)

    #######################################
    #*********create ppt for cancellation
    cancppt = Policypremiumtransaction.new(canc_params)
    cancppt.transaction_type = "Cancel"
    cancppt.cash_received = money_received
    cancppt.policy_id = self.id

    #this is here to translate the date format used in the application to the format
    #used in the DB
    effdate = Date.new
    effdate = Date.strptime(canc_params[:transaction_effective_date].to_s, '%m/%d/%Y')
    cancppt.transaction_effective_date = effdate

    cancppt.save
    #***********end create ppt for cancellation
    #######################################

    #######################################
    #set policy status to cancelled
    self.status = "Cancelled"
    #set policy expiration date to the effective date of cancellation
    self.expiration_date = effdate
    self.save
    ######################################


    #get line of business for carrier and commission
    carrierlob = Carrierlob.where("carrier_id =? AND lineofbusiness_id =?", self.carrier_id,self.lineofbusiness_id )
    commission = Lobcommission.where("carrierlob_id =? AND state = ?", carrierlob[0].id, self.state )


    ######################################
    #************create invoice

    invoice = Invoice.new

    if !commission[0].producer_rate.nil?

      # if there is a rate for producers, then deduct it from the invoice and if there are complexfees
      # calculate the commission net of the complex fees


      if !canc_params[:complexfees].nil?

        complex = canc_params[:complexfees]

        invoice.createinvoice(cancppt.transaction_effective_date, (cancppt.total_premium + (((-1* cancppt.total_premium) + complex)*commission[0].producer_rate)) , cancppt.id)
      else
        invoice.createinvoice(cancppt.transaction_effective_date, (cancppt.total_premium + ((-1* cancppt.total_premium)*commission[0].producer_rate)) , cancppt.id)
      end
    else

      invoice.createinvoice(cancppt.transaction_effective_date, cancppt.total_premium , cancppt.id)

    end

    #************end create invoice
    #if the policy has a balance on it, call method to apply cancellation to balance
    if self.payment_type_id != 5 # direct bill wont have a balance

      if self.arbalance != 0

        self.cancellationtoinvoice(cancppt.total_premium, cancppt.base_premium, cancppt.complexfees, cancppt.id)

      else
        ## calculate commission to subtract from return
        producercommamt = 0
        if self.isga =="GA"

          @carrierlob = Carrierlob.where("carrier_id =? AND lineofbusiness_id =?", self.carrier_id,self.lineofbusiness_id )
          @commission = Lobcommission.where("carrierlob_id =? AND state = ?", @carrierlob[0].id, self.state )

          producercommamt = (cancppt.base_premium *  @commission[0].producer_rate)

        end


        @accountingevent = Accountingevent.new

        @accountingevent.transaction_type = 'Cancel Applied to Invoice Overage'
        @accountingevent.policy_id =  self.id
        @accountingevent.total_premium = cancppt.total_premium
        @accountingevent.base_premium = cancppt.base_premium - producercommamt  + cancppt.complexfees
        @accountingevent.carrier_id = self.carrier.id
        @accountingevent.state = self.state
        @accountingevent.line_id = self.lineofbusiness_id

        @accountingevent.policypremiumtransaction_id = cancppt.id
        @accountingevent.recordaccountingevent
      end
    end
  end


  def cancelsimple(canc_params)
    #######################################
    #*********create ppt for cancellation
    cancppt = Policypremiumtransaction.new
    cancppt.transaction_type = "Cancel Pending Statement"
    cancppt.cash_received = 0
    cancppt.policy_id = self.id

    #this is here to translate the date format used in the application to the format
    #used in the DB
    effdate = Time.now
    begin
      effdate = Date.strptime(canc_params[:transaction_effective_date].to_s, '%m/%d/%Y')
    rescue
    end
    cancppt.transaction_effective_date = effdate

    cancppt.save
    #***********end create ppt for cancellation
    #######################################

    #######################################
    #set policy status to cancelled
    self.status = "Cancelled"
    #set policy expiration date to the effective date of cancellation
    self.expiration_date = effdate
    self.save
    ######################################



  end

  def reinstate(policy_id)
    #reinstatement gets all transactions from previous cancellation and reverses them, hence the -1s

    #set policy status to active
    @policy = Policy.find(policy_id)

    @policy.status = "Active"

    if @policy.policy_term == '12 Month'
      @policy.expiration_date = @policy.effective_date + 1.year
    elsif @policy.policy_term = '6 Month'
      @policy.expiration_date = @policy.effective_date + 6.months
    end

    @policy.save

    @policypremiumtrans = Policypremiumtransaction.where("policy_id = ? AND (transaction_type = 'Cancel' OR transaction_type = 'Cancel Pending Statement')",policy_id).last
    @reinstatementppt = Policypremiumtransaction.new
    @reinstatementppt.transaction_type = "Reinstate"
    @reinstatementppt.policy_id = policy_id
    @reinstatementppt.transaction_effective_date = @policypremiumtrans.transaction_effective_date
    if @policypremiumtrans.transaction_type == 'Cancel'
      @reinstatementppt.base_premium = @policypremiumtrans.base_premium * -1
      @reinstatementppt.total_premium = @policypremiumtrans.total_premium * -1



      @reinstatementppt.cash_received = @policypremiumtrans.cash_received
      if  !@policypremiumtrans.complexfees.nil?
        @reinstatementppt.complexfees = @policypremiumtrans.complexfees * -1
      end
      if  !@policypremiumtrans.fees.nil?
        @reinstatementppt.fees = @policypremiumtrans.fees * -1
      end
    end

    @reinstatementppt.save
    # end ppt

    if  @policypremiumtrans.transaction_type == 'Cancel'


      ##set cancellation to 0
      @policypremiumtrans.cashtransactions.each do |ct|
        @reducereturninvoice = Cashtransaction.new
        @reducereturninvoice.invoice_id = ct.invoice_id
        @reducereturninvoice.policypremiumtransaction_id = @policypremiumtrans.id
        @reducereturninvoice.transaction_type = "Reinstatement"
        @reducereturninvoice.cash_amount = ct.cash_amount * -1
        @reducereturninvoice.save


      end


      @cashtransinvoice = @policypremiumtrans.invoices.last.id

      ########
      #create invoice

      # @invoice = Invoice.new

      @carrierlob = Carrierlob.where("carrier_id =? AND lineofbusiness_id =?", @policy.carrier_id,@policy.lineofbusiness_id )

      @commission = Lobcommission.where("carrierlob_id =? AND state = ?", @carrierlob[0].id, @policy.state )

      #since cancellations are negative, we need to reverse the sign


      if !@commission[0].producer_rate.nil?

        # if there is a rate for producers, then deduct it from the invoice and if there are complexfees
        # calculate the commission net of the complex fees
        if !@reinstatementppt.complexfees.nil?


          # @invoice.createinvoice(@reinstatementppt.transaction_effective_date, (@reinstatementppt.total_premium  - (( @reinstatementppt.total_premium - @reinstatementppt.complexfees) * @commission[0].producer_rate)) , @reinstatementppt.id)
          @reducereturninvoice = Cashtransaction.new
          @reducereturninvoice.invoice_id = @cashtransinvoice
          @reducereturninvoice.policypremiumtransaction_id = @policypremiumtrans.id
          @reducereturninvoice.transaction_type = "Reinstatement"
          @reducereturninvoice.cash_amount = ((@reinstatementppt.total_premium  - (( @reinstatementppt.total_premium - @reinstatementppt.complexfees) * @commission[0].producer_rate))) * -1
          @reducereturninvoice.save
        else

          # @invoice.createinvoice(@policypremiumtrans.transaction_effective_date, (@policypremiumtrans.total_premium - (( @policypremiumtrans.total_premium)*@commission[0].producer_rate)) , @reinstatementppt.id)
          @reducereturninvoice = Cashtransaction.new
          @reducereturninvoice.invoice_id = @cashtransinvoice
          @reducereturninvoice.policypremiumtransaction_id = @policypremiumtrans.id
          @reducereturninvoice.transaction_type = "Reinstatement"
          @reducereturninvoice.cash_amount = (@policypremiumtrans.total_premium - (( @policypremiumtrans.total_premium)*@commission[0].producer_rate)) * -1
          @reducereturninvoice.save
        end
      else


        #@invoice.createinvoice(@policypremiumtrans.transaction_effective_date, @policypremiumtrans.total_premium , @reinstatementppt.id)
        @reducereturninvoice = Cashtransaction.new
        @reducereturninvoice.invoice_id = @cashtransinvoice
        @reducereturninvoice.policypremiumtransaction_id = @policypremiumtrans.id
        @reducereturninvoice.transaction_type = "Reinstatement"
        @reducereturninvoice.cash_amount = @policypremiumtrans.total_premium  * -1
        @reducereturninvoice.save
      end
      ######


      #reversing fees, loop through reversing sign
      if !@policypremiumtrans.complexfees.nil?
        fees = Feetransaction.find_all_by_policypremiumtransaction_id(@policypremiumtrans)

        fees.each do |fee|
          tempfee = Feetransaction.new
          tempfee.policypremiumtransaction_id = @reinstatementppt.id
          tempfee.fee_amount = (fee.fee_amount * -1)
          tempfee.fee_id = fee.fee_id
          tempfee.save

        end


      end
    end


  end

  def paycarrier(cashamount,  policy_id)

    @cashtransaction = Cashtransaction.new
    @cashtransaction.cash_amount = cashamount

    @cashtransaction.paycarrier
    @cashtransaction.policy_id = policy_id
    @cashtransaction.save


  end


###END POLICY TRANSACTIONS###
############################################################################################

  def annualpremium
    @ppt = Policypremiumtransaction.find_all_by_policy_id(self.id)

    @annualsum = 0.00
    @ppt.each do |premium|
      if premium.transaction_type =="New" or  premium.transaction_type =="Endorse"  or  premium.transaction_type =="Return Premium" or  premium.transaction_type =="Renew"  or  premium.transaction_type =="Adjust"
        @annualsum=  @annualsum + premium.total_premium
      end
    end

    @annualsum
  end

  def annualpremiumbase
    @ppt = Policypremiumtransaction.find_all_by_policy_id(self.id)

    @annualsum = 0.00
    @ppt.each do |premium|
      if premium.transaction_type =="New" or  premium.transaction_type =="Endorse"  or  premium.transaction_type =="Return Premium" or  premium.transaction_type =="Renew"  or  premium.transaction_type =="Adjust"
        @annualsum=  @annualsum + premium.base_premium
      end
    end

    @annualsum
  end

  def cancellationtoinvoice(returnpremium, basepremium, complexfees, cancppt_id)
    @producercommamt = 0
    cancppt = Policypremiumtransaction.find(cancppt_id)

    @invreturnpremium = returnpremium * -1
    @amountappliedrunningt = 0



    #only deal with commissions if GA for now
    if self.isga =="GA"

      @carrierlob = Carrierlob.where("carrier_id =? AND lineofbusiness_id =?", self.carrier_id,self.lineofbusiness_id )
      @commission = Lobcommission.where("carrierlob_id =? AND state = ?", @carrierlob[0].id, self.state )
      @producercommamt = (basepremium *  @commission[0].producer_rate)
      @invreturnpremium = @invreturnpremium + @producercommamt #+ complexfees
    end


    @pptforview = Policypremiumtransaction.find_all_by_policy_id(self.id)



    @invoices = Invoice.find_all_by_policypremiumtransaction_id(@pptforview)

    @invoices.each do |inv|
      @amountappliedtoinvoice =0
      if inv.is_paid == "Not Paid" || inv.is_paid == "Overpaid"


        if @invreturnpremium > 0 then
          if inv.policypremiumtransaction.transaction_type != "Cancel"
            if inv.policypremiumtransaction.transaction_type != "Return Premium"
              @cashtoinvoice = Cashtransaction.new
              @cashtoinvoice.invoice_id = inv.id
              @cashtoinvoice.transaction_type = "Applied to Invoice Balance"

              #using ppt of the cancellation not the ppt associated with this invoice - this is used in the reinstatement process
              @cashtoinvoice.policypremiumtransaction_id = cancppt_id
              if inv.outstandingbalance < 0
                if @invreturnpremium > (inv.outstandingbalance * -1)
                  #for invoices with negative values,# we dont want to apply more cash than needed to the invoice ( I AM SURE THERE IS A MORE ELEGANT WAY...but shipping > elegance)
                  @cashtoinvoice.cash_amount = inv.outstandingbalance

                  @amountappliedtoinvoice = inv.outstandingbalance

                  @invreturnpremium = @invreturnpremium - (inv.outstandingbalance * -1)
                else
                  @cashtoinvoice.cash_amount = @invreturnpremium
                  @amountappliedtoinvoice =  @invreturnpremium
                  @invreturnpremium = 0
                end
              else
                if @invreturnpremium > inv.outstandingbalance
                  #we dont want to apply more cash than needed to the invoice
                  @cashtoinvoice.cash_amount = inv.outstandingbalance
                  @amountappliedtoinvoice = inv.outstandingbalance
                  @invreturnpremium = @invreturnpremium - inv.outstandingbalance
                else
                  @cashtoinvoice.cash_amount = @invreturnpremium
                  @amountappliedtoinvoice =  @invreturnpremium
                  @invreturnpremium = 0
                end
              end
              @cashtoinvoice.save


            end
          end
        end
      end

      @amountappliedrunningt = @amountappliedrunningt + @amountappliedtoinvoice


    end


    #we now do a reversing accounting transaction for the amount we applied to the invoice
    @accountingevent = Accountingevent.new

    @accountingevent.transaction_type = 'Cancel Applied to Invoice'
    @accountingevent.total_premium = @amountappliedrunningt

    @accountingevent.policy_id =  self.id
    @accountingevent.base_premium = @amountappliedrunningt
    @accountingevent.carrier_id = self.carrier.id
    @accountingevent.state = self.state
    @accountingevent.line_id = self.lineofbusiness_id
    @accountingevent.complexfees = complexfees
    @pptforappliedtoinv = Policypremiumtransaction.find_all_by_policy_id(self.id).last
    @accountingevent.policypremiumtransaction_id = @pptforappliedtoinv.id
    @accountingevent.recordaccountingevent

    #if anything left over, create a payable to producer or policyholder
    if (returnpremium + @amountappliedrunningt - @producercommamt) !=0

      @accountingevent = Accountingevent.new

      @accountingevent.transaction_type = 'Cancel Applied to Invoice Overage'
      @accountingevent.total_premium = @amountappliedrunningt
      @accountingevent.policy_id =  self.id
      @accountingevent.base_premium = (returnpremium + @amountappliedrunningt - @producercommamt) * -1
      @accountingevent.carrier_id = self.carrier.id
      @accountingevent.state = self.state
      @accountingevent.line_id = self.lineofbusiness_id
      #@accountingevent.complexfees = complexfees
      #@pptforappliedtoinv = Policypremiumtransaction.find_all_by_policy_id(self.id).last
      @accountingevent.policypremiumtransaction_id = @pptforappliedtoinv.id
      @accountingevent.recordaccountingevent
    end




    #reduce this cancellation invoice by the amount spread across all other invoices


    cancinvoice = Invoice.find_all_by_policypremiumtransaction_id(cancppt.id).last


    @reducereturninvoice = Cashtransaction.new
    @reducereturninvoice.invoice_id = cancinvoice.id
    @reducereturninvoice.policypremiumtransaction_id = cancppt_id
    @reducereturninvoice.transaction_type = "Applied to Outstanding Invoice"
    @reducereturninvoice.cash_amount = @amountappliedrunningt * -1
    @reducereturninvoice.save



  end



  def expirepolicies
    policies = Policy.where("expiration_date < ?", Date.today - 30.days)

    policies.each do |pol|

      if pol.status == "Active"
        pol.status = "Expired"
        pol.save
      end

    end

  end

  def expirepoliciestask
    policies = Policy.where("expiration_date = ?", Date.today + 30.days)

    policies.each do |pol|
      if pol.status != "Renewed" && pol.status !="Cancelled"  && pol.status !="Expired"

        if pol.agency_id ==2
          newtask = Task.new
          newtask.policy_id = pol.id
          newtask.task_name = "Renewal Contact"
          newtask.agency_id = pol.agency_id
          newtask.agent_id = 7
          newtask.reminder_date = pol.expiration_date - 30.days
          newtask.save

        end

      end
    end

  end

  def expirepoliciestaskahead
    policies = Policy.where("expiration_date < ?", Date.today + 30.days)

    policies.each do |pol|
      if pol.status != "Renewed" && pol.status !="Cancelled"  && pol.status !="Expired"

        if pol.agency_id ==2
          newtask = Task.new
        end
      end
    end
  end


  def nonrenew
    if self.is_nonrenew?
      self.is_nonrenew  = false
    else
      self.is_nonrenew  = true
      self.nonrenew_set_date = Time.now.getutc
    end
    self.save
  end


  def pendingcancellation
    if self.is_pendingcancellation?
      self.is_pendingcancellation  = false
    else
      self.is_pendingcancellation  = true
      self.pendingcancellation_set_date = Time.now.getutc
    end
    self.save
  end


  def updatecommission(newrate)
    ppt = Policypremiumtransaction.find_all_by_policy_id(self.id)
    oldrate = self.producercommrate
    self.cond_comm_producer = newrate

    #go through all ppts and adjust commission
    ppt.each do |p|
      p.updatecommission( self.producercommrate, oldrate )
    end

    self.save
  end
end
