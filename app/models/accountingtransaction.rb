class Accountingtransaction < ActiveRecord::Base
  before_save :createbookmonthyear, :getagencyinfo, :createeffective
  belongs_to :invoice
  belongs_to :policypremiumtransaction
  belongs_to :policy
  belongs_to :cashtransaction


  ##### validations begin
  VALID_TRANSACTIONS = %w(Debit Credit)
  validates :account_id, :presence => true
  validates :trans_type, :inclusion => {:in =>VALID_TRANSACTIONS, :message => "transaction type %s is not allowed"}
  validates :policy_id, :presence => true

  ##### validations end

  def transactionreport(agency_id, start, enddate)


  end

  def createeffective
    now = Date.today
    if !self.policypremiumtransaction.nil?
      self.effective_month = self.policypremiumtransaction.transaction_effective_date.month
      self.effective_year = self.policypremiumtransaction.transaction_effective_date.year
      self.transaction_effective_date = self.policypremiumtransaction.transaction_effective_date
    else
      self.effective_month = now.month
      self.effective_year = now.year
      self.transaction_effective_date = now
    end
  end

  def createbookmonthyear
    now = Date.today

    self.book_month = now.month
    self.book_year =  now.year
    self.book_date = now

  end

  def getagencyinfo
    if self.policy.isga == "GA"
      self.generalagency_id = self.policy.generalagency_id
    else
      self.agency_id = self.policy.agency_id
    end


  end

  def commissionforchart(agency_id, atype)
    if atype =="Retail"
      @commission = Accountingtransaction.find_by_sql(["SELECT book_month, book_year, SUM(amount) as commission FROM accountingtransactions acc GROUP BY acc.book_month, acc.book_year, acc.agency_id, acc.account_id  HAVING acc.agency_id = ? AND acc.book_year = ? AND acc.account_id = 30001 ORDER BY acc.book_year ASC, acc.book_month ASC",  agency_id, Date.today.year ])

    else
      @commission = Accountingtransaction.find_by_sql(["SELECT book_month, book_year, SUM(amount) as commission FROM accountingtransactions acc GROUP BY acc.book_month, acc.book_year, acc.generalagency_id, acc.account_id  HAVING acc.generalagency_id = ? AND acc.book_year = ? AND acc.account_id = 30001 ORDER BY acc.book_year ASC, acc.book_month ASC",  agency_id, Date.today.year])
    end
  end


  def premiumforwcmonthly( nonwc )
    @premiun = Accountingtransaction.find_by_sql(["
      SELECT ppt.book_month, SUM(ppt.base_premium) as premium
      FROM policypremiumtransactions ppt
        JOIN policies p ON ppt.policy_id = p.id
        JOIN lineofbusinesses lob on p.lineofbusiness_id::int = lob.id
      WHERE ppt.book_year = ?
        AND ppt.transaction_type = 'New'
        AND lob.generalagency_id = 1
        AND #{ nonwc ? "NOT" : "" } lob.line_name IN ( 'Workers Compensation', 'Worker\'\'s Comp - Agency Bill', 'Workers Comp (CP-AM Renewal)', 'Workers Comp (Renewal)' )
      GROUP BY ppt.book_month
      ORDER BY ppt.book_month",
      Date.today.year])
  end


  def commissionforreport(agency_id, atype, startdate, enddate, carrier_id, datetype, location)

    if datetype == "effective"
      dt = "transaction_effective_date"
      ordermo = "effective_month"
      orderyr = "effective_year"
    else
      dt = "book_date"
      ordermo = "book_month"
      orderyr = "book_year"
    end

    if location == "all"
      loc = ""
    else
      loc = " AND clients.location_id = #{location}"
    end

    if atype =="Retail"

      if carrier_id == "all"

        @commission = Accountingtransaction.order("#{dt} ASC").joins(:policypremiumtransaction => [{:policy => :client}]).where("account_id = 30001 AND accountingtransactions.#{dt} >= ? AND accountingtransactions.#{dt} <= ? #{loc}", startdate, enddate).find_all_by_agency_id(agency_id)

      else
        @commission = Accountingtransaction.order("#{dt} ASC").joins(:policypremiumtransaction => [{:policy => :client}] ).where("account_id = 30001 AND accountingtransactions.#{dt} >= ? AND accountingtransactions.#{dt} <= ? AND policies.carrier_id = ? #{loc}", startdate, enddate, carrier_id).find_all_by_agency_id(agency_id)

      end
    else

      if carrier_id == "all"
        @commission = Accountingtransaction.order("#{dt} ASC").where("account_id = 30001 AND #{dt} >= ? AND #{dt} <= ? ", startdate, enddate).find_all_by_generalagency_id(agency_id)

      else
        @commission = Accountingtransaction.order("#{dt} ASC").joins(:policypremiumtransaction => [{:policy => :client}]).where("account_id = 30001 AND accountingtransactions.#{dt} >= ? AND accountingtransactions.#{dt} <= ? AND policies.carrier_id = ? AND accountingtransactions.generalagency_id = ?", startdate, enddate, carrier_id, agency_id)

      end

    end
  end

  def unearnedcommissionforreport(agency_id, atype, startdate, enddate, carrier_id, datetype, location)
    if datetype == "effective"
      dt = "transaction_effective_date"
      ordermo = "effective_month"
      orderyr = "effective_year"
    else
      dt = "book_date"
      ordermo = "book_month"
      orderyr = "book_year"
    end
    if location == "all"
      loc = ""
    else
      loc = " AND clients.location_id = #{location}"
    end

    if atype =="Retail"

      if carrier_id == "all"
        @commission = Accountingtransaction.order("#{dt} ASC").joins(:policypremiumtransaction => [{:policy => :client}]).where("policypremiumtransactions.reconciled is null AND accountingtransactions.account_id = 20002 AND accountingtransactions.#{dt} >= ? AND accountingtransactions.#{dt} <= ?  #{loc} ", startdate, enddate).find_all_by_agency_id(agency_id)

      else
        @commission = Accountingtransaction.order("#{dt} ASC").joins(:policypremiumtransaction => [{:policy => :client}]).where("policypremiumtransactions.reconciled is null AND accountingtransactions.account_id = 20002 AND accountingtransactions.#{dt} >= ? AND accountingtransactions.#{dt} <= ? AND policies.carrier_id = ?  #{loc}", startdate, enddate, carrier_id).find_all_by_agency_id(agency_id)

      end
    else

      if carrier_id == "all"
        @commission = Accountingtransaction.order("#{dt} ASC").where("account_id = 20002 AND #{dt} >= ? AND #{dt} <= ? ", startdate, enddate).find_all_by_generalagency_id(agency_id)

      else
        @commission = Accountingtransaction.order("#{dt} ASC").joins(:policypremiumtransaction => [{:policy => :client}]).where("account_id = 20002 AND accountingtransactions.#{dt} >= ? AND accountingtransactions.#{dt} <= ? AND policies.carrier_id = ? AND accountingtransactions.generalagency_id = ?", startdate, enddate, carrier_id, agency_id)

      end

    end
  end

  def commissionexpforreport(agency_id, atype, startdate, enddate, carrier_id, datetype)
    if datetype == "effective"
      dt = "transaction_effective_date"
      ordermo = "effective_month"
      orderyr = "effective_year"
    else
      dt = "book_date"
      ordermo = "book_month"
      orderyr = "book_year"
    end

    if atype =="Retail"

      if carrier_id == "all"
        @commission = Accountingtransaction.order("#{dt} ASC").where("account_id = 40001 AND #{dt} >= ? AND #{dt} <= ?", startdate, enddate).find_all_by_agency_id(agency_id)

      else
        @commission = Accountingtransaction.order("#{dt} ASC").joins(:policypremiumtransaction => :policy).where("account_id = 40001 AND accountingtransactions.#{dt} >= ? AND accountingtransactions.#{dt} <= ? AND policies.carrier_id = ?", startdate, enddate, carrier_id).find_all_by_agency_id(agency_id)

      end
    else
      if carrier_id == "all"
        @commission = Accountingtransaction.order("#{dt} ASC").where("account_id = 40001 AND #{dt} >= ? AND #{dt} <= ?", startdate, enddate).find_all_by_generalagency_id(agency_id)

      else
        @commission = Accountingtransaction.order("#{dt} ASC").joins(:policypremiumtransaction => :policy).where("account_id = 40001 AND accountingtransactions.#{dt} >= ? AND accountingtransactions.#{dt} <= ? AND policies.carrier_id = ?", startdate, enddate, carrier_id).find_all_by_generalagency_id(agency_id)

      end
    end
  end

end
