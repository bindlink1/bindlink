class Invoice < ActiveRecord::Base
  before_save :createbookmonthyear, :addagencyassociations
  after_save :setcurrent
  belongs_to :client
  has_one :agency, :through => :policies
  has_one :generalagency, :through => :policies
  belongs_to :policypremiumtransaction
  belongs_to :policy
  belongs_to :producingagency
  has_many :accountingtransactions, :dependent => :destroy
  has_many :cashtransactions, :dependent => :destroy


  attr_accessible :comm_fees, :commission, :description, :due_on, :down_payment, :fees, :non_comm_fees, :taxes, :total_billed
  def setcurrent

    $currentinvoice = self.id

  end

  def isoverdue
    @today = Date.today
    @today = @today
    @status

    #reinstatement invoices currently do not have due dates, and will break the query
    if self.policypremiumtransaction.transaction_type != "Reinstate" then
      if self.due_on < @today
        if self.outstandingbalance > 0 then
          @status = "Overdue"
        else
          @status = "Current"
        end

      else
        @status = "Current"
      end

    else

      @status="current"
    end
  end

  def self.get_all_from_today
    Invoice.count
  end

  def self.getbyagencyid

    Invoice.joins(:policypremiumtransactions)

  end

  def is_paid
    @balance = self.outstandingbalance
    if @balance ==  0
      "Paid"
    elsif @balance <  0
      "Overpaid"
    else

      "Not Paid"

    end
  end

  def createbookmonthyear

    @createdon = Date.today


    self.book_month = @createdon.month
    self.book_year = @createdon.year
  end


  def addagencyassociations
    if $currentagenttype == "Retail"
      self.agency_id = $agencyid
    else
      self.generalagency_id = $generalagentid
      self.producingagency_id = $currentproducer
    end
  end


  def outstandingbalance
    invoice = Invoice.find(self.id)
    begin
      cashtransactions = Cashtransaction.where("invoice_id = ?", self.id).sum("cash_amount")
    rescue
      cashtransactions = 0
    end

    if !invoice.total_billed
      invoice.total_billed = 0
    end

    output = invoice.total_billed.round(2) - cashtransactions
  end

=begin
  def balanceforthedatecreated
    invoice = Invoice.find(self.id)
    begin
      cashtransactions = Cashtransaction.where( "invoice_id = ? and book_date <= ?", self.id, invoice.createdon ).sum( "cash_amount" )
    rescue
      cashtransactions = 0
    end

    if !invoice.total_billed
      invoice.total_billed = 0
    end

    output = invoice.total_billed.round(2) - cashtransactions
  end
=end

  #working to switch over to this invoice creation method
  def createinvoicenew ( effective_date, total_premium, ppt_id, policy_id)
    @invoice = Invoice.new

    @policy = Policy.find(policy_id)

    @ppt = Policypremiumtransaction.find(ppt_id)
    if @policy.payment_type_id == 1
      if @policy.isga == "GA"

        #get commission rate for GA producers
        @carrierlob = Carrierlob.where("carrier_id =? AND lineofbusiness_id =?", @policy.carrier_id,@policy.lineofbusiness_id )
        @commission = Lobcommission.where("carrierlob_id =? AND state = ?", @carrierlob[0].id, @policy.state )
        if !@policy.cond_comm_producer.nil?
          @producercommamt =  @policy.cond_comm_producer

        else
          @producercommamt =  @commission[0].producer_rate
        end

        total_billed = @ppt.base_premium + @ppt.complexfees - (@ppt.base_premium * @producercommamt ).round(2)
      else
        total_billed = total_premium
      end
    end


    if !@policy.carrier.days_invoice_due.nil?
      daysdue = @policy.carrier.days_invoice_due
    else
      daysdue = 15
    end


    @invoice.due_on = effective_date + daysdue.days
    @invoice.total_billed = total_billed
    @invoice.policypremiumtransaction_id = ppt_id

    @invoice.save



  end

  def adjustinvoice(invoice_id, ppt_id)
    @invoice = Invoice.find(invoice_id)
    @ppt = Policypremiumtransaction.find(ppt_id)
    @policy = Policy.find(@ppt.policy_id)


    if @policy.payment_type_id == 1
      if @policy.isga == "GA"

        #get commission rate for GA producers
        @carrierlob = Carrierlob.where("carrier_id =? AND lineofbusiness_id =?", @policy.carrier_id,@policy.lineofbusiness_id )
        @commission = Lobcommission.where("carrierlob_id =? AND state = ?", @carrierlob[0].id, @policy.state )
        if !@policy.cond_comm_producer.nil?
          @producercommamt =  @policy.cond_comm_producer

        else
          @producercommamt =  @commission[0].producer_rate
        end

        billing_change = @ppt.base_premium + @ppt.complexfees - (@ppt.base_premium * @producercommamt )
      else
        billing_change = @ppt.total_premium
      end

      @invoice.total_billed = @invoice.total_billed + billing_change

      @invoice.save
    end


  end



  def createinvoice ( effective_date, total_billed, ppt_id)
    @invoice = Invoice.new


    @ppt = Policypremiumtransaction.find(ppt_id)

    if !@ppt.policy.carrier.days_invoice_due.nil?
      daysdue = @ppt.policy.carrier.days_invoice_due
    else
      daysdue = 15
    end


    @invoice.due_on = effective_date + daysdue.days

    @invoice.total_billed = total_billed
    @invoice.policypremiumtransaction_id = ppt_id

    @invoice.save



  end

  def invoiceage
    @today = Date.today
    @daysaged = 0
    if self.is_paid == "Not Paid"
      @daysaged = @today - self.due_on
      if @daysaged < 0
        @daysaged = 0
      end
    end

    @daysaged.to_i
  end


  def paymentcount
   Cashtransaction.find_all_by_invoice_id(self.id).count()
  end


  def self.agedinvoicecount(i)
    count = self.agedinvoice(i).count
  end


  def self.agedinvoice(i)
    joins = "
        JOIN policypremiumtransactions ppt2 ON invoices.policypremiumtransaction_id = ppt2.id
        LEFT JOIN ( SELECT invoice_id, SUM( cash_amount ) amount FROM cashtransactions GROUP BY invoice_id
          ) c2 ON c2.invoice_id = invoices.id
        JOIN (
            SELECT p.id
            FROM policies p
              JOIN policypremiumtransactions ppt ON ppt.policy_id = p.id
              JOIN invoices i ON i.policypremiumtransaction_id = ppt.id
              LEFT JOIN ( SELECT invoice_id, SUM( cash_amount ) amount FROM cashtransactions GROUP BY invoice_id
                    ) c ON c.invoice_id = i.id
            WHERE p.generalagency_id = 1 AND payment_type_id IN ( 1, 2, 3, 4 )
            GROUP BY p.id
            HAVING COALESCE( SUM( i.total_billed ), 0 ) - COALESCE( SUM( c.amount ), 0 ) > 0.01
          ) p2 ON ppt2.policy_id = p2.id
      "
    dateperiod =   "now()::date - 10 AND now()::date - 1"
    if i == 11
      dateperiod = "now()::date - 15 AND now()::date - 11"
    elsif i == 16
      dateperiod = "now()::date - 25 AND now()::date - 16"
    elsif i == 26
      dateperiod = "'2017-01-01' AND now()::date - 26"
    end
    where = "
        COALESCE( invoices.total_billed, 0 ) - COALESCE( c2.amount, 0 ) > 0.01
        AND invoices.due_on BETWEEN " + dateperiod
    #puts Invoice.joins( joins ).where( where ).to_sql
    inv = Invoice.joins( joins ).where( where )
  end


  def self.pastdueinvoice( shiftstart, shiftend )
    joins = "
        JOIN policypremiumtransactions ppt2 ON invoices.policypremiumtransaction_id = ppt2.id
        LEFT JOIN ( SELECT invoice_id, SUM( cash_amount ) amount FROM cashtransactions GROUP BY invoice_id
          ) c2 ON c2.invoice_id = invoices.id
        JOIN (
            SELECT p.id, p.policy_number
            FROM policies p
              JOIN policypremiumtransactions ppt ON ppt.policy_id = p.id
              JOIN invoices i ON i.policypremiumtransaction_id = ppt.id
              LEFT JOIN ( SELECT invoice_id, SUM( cash_amount ) amount FROM cashtransactions GROUP BY invoice_id
                    ) c ON c.invoice_id = i.id
            WHERE p.generalagency_id = 1
              AND payment_type_id IN ( 1, 2, 3, 4 )
              AND p.status = 'Active'
            GROUP BY p.id, p.policy_number
            HAVING COALESCE( SUM( i.total_billed ), 0 ) - COALESCE( SUM( c.amount ), 0 ) > 0.01
          ) p2 ON ppt2.policy_id = p2.id"
    where = "
        COALESCE( invoices.total_billed, 0 ) - COALESCE( c2.amount, 0 ) > 0.01
        AND invoices.due_on BETWEEN now()::date - #{shiftend} AND now()::date - #{shiftstart} "
    #puts Invoice.joins( joins ).where( where ).to_sql
    inv = Invoice.joins( joins ).where( where )
  end

end
