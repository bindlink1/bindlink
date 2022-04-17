require 'net/http'
#require 'savon'
require 'securerandom'

class ReportsController < ApplicationController
  layout 'applicationfunctional'
  before_filter :login_marshall

  set_tab :reporthome, :sidenav

  def index
    @cashreport = Cashtransaction.new
    @policylistingreport = Policypremiumtransaction.new
    @accounttransactionreport = Accountingtransaction.new
    @newreport = Report.new

    if current_agent.isgeneralagent == "Retail"
      @carriers = Carrier.order("carrier_name").find_all_by_agency_id(current_agent.agency_id)
      @linesofbusiness =  Lineofbusiness.order("line_name").find_all_by_agency_id(current_agent.agency_id)
      @location = Location.order("main_location_flag desc").find_all_by_agency_id(current_agent.agency_id)
    else
      @carriers = Carrier.order("carrier_name").find_all_by_generalagency_id(current_agent.generalagency_id)
      @linesofbusiness =  Lineofbusiness.order("line_name").find_all_by_generalagency_id(current_agent.generalagency_id)
      @location = Location.find_all_by_generalagency_id(current_agent.generalagency_id)
    end
  end


  def commissionreport
    startdate =  Date.strptime(params[:start_date].to_s, '%m/%d/%Y')
    enddate =Date.strptime(params[:end_date].to_s, '%m/%d/%Y')
    #startdate =startdate + 0.hours + 0.minutes
    #enddate= enddate+23.hours+59.minutes
    datetype = params[:datetype]
    location = params[:commissionlocation]
    if params[:commissioncarrier].to_s == "all"

      if current_agent.isgeneralagent == "Retail"

        @commissionrev = Accountingtransaction.new.commissionforreport(current_agent.agency_id,"Retail", startdate, enddate, "all", datetype, location)
        @commissionexp = Accountingtransaction.new.commissionexpforreport(current_agent.agency_id,"Retail", startdate, enddate, "all", datetype)

        @unearned = Accountingtransaction.new.unearnedcommissionforreport(current_agent.agency_id,"Retail", startdate, enddate, "all", datetype, location)

      else
        @commissionrev = Accountingtransaction.new.commissionforreport(current_agent.generalagency_id,"GA", startdate, enddate, "all", datetype, location)
        @commissionexp = Accountingtransaction.new.commissionexpforreport(current_agent.generalagency_id,"GA", startdate, enddate, "all", datetype)
      end

    else
      if current_agent.isgeneralagent == "Retail"
        @commissionrev = Accountingtransaction.new.commissionforreport(current_agent.agency_id,"Retail", startdate, enddate, params[:commissioncarrier], datetype, location)
        @commissionexp = Accountingtransaction.new.commissionexpforreport(current_agent.agency_id,"Retail", startdate, enddate, params[:commissioncarrier], datetype)
        @unearned = Accountingtransaction.new.unearnedcommissionforreport(current_agent.agency_id,"Retail", startdate, enddate, params[:commissioncarrier], datetype, location)
      else
        @commissionrev = Accountingtransaction.new.commissionforreport(current_agent.generalagency_id,"GA", startdate, enddate, params[:commissioncarrier], datetype, location)
        @commissionexp = Accountingtransaction.new.commissionexpforreport(current_agent.generalagency_id,"GA", startdate, enddate, params[:commissioncarrier], datetype)
      end

    end

    @revenuetotal = 0
    @revenuenew = 0
    @revenueendorse = 0
    @revenuecancel = 0
    @revenuereinstate = 0
    @revenuereturn = 0
    @revenuerenew = 0
    @premiumnew = 0
    @premiumrenew = 0
    @premiumreinstate = 0
    @premiumcancel = 0
    @premiumendorse = 0
    @premiumreturn = 0
    @premiumtotal = 0

    @countnew = 0
    @countrenew = 0
    @countreinstate = 0
    @countcancel = 0
    @countendorse = 0
    @countreturn = 0
    @counttotal = 0

    @policycountnew = 0
    @policycountrenew = 0


    @unearnedtotal = 0
    @unearnednew = 0
    @unearnedendorse = 0
    @unearnedcancel = 0
    @unearnedreinstate = 0
    @unearnedreturn = 0
    @unearnedrenew = 0

    @expensetotal = 0
    @expensenew = 0
    @expenseendorse = 0
    @expensecancel = 0
    @expensereinstate = 0
    @expensereturn = 0

    @commissionrev.each do |rev|
      revenue = 0
      if rev.trans_type == "Credit"
        revenue= rev.amount
      else
        revenue = (rev.amount * -1)
      end

      @revenuetotal =  @revenuetotal + revenue
      @premiumtotal = @premiumtotal + begin rev.policypremiumtransaction.total_premium rescue 0 end
      @counttotal = @counttotal + 1

      if !rev.policypremiumtransaction.nil?
        if rev.policypremiumtransaction.transaction_type == "New"

          begin @revenuenew =  @revenuenew + revenue      end
          @premiumnew = @premiumnew +  begin rev.policypremiumtransaction.total_premium rescue 0   end
          begin @countnew = @countnew + 1 end
        elsif  rev.policypremiumtransaction.transaction_type == "Renew"
          begin @revenuerenew =  @revenuerenew + revenue end
          @premiumrenew = @premiumrenew + begin rev.policypremiumtransaction.total_premium rescue 0 end
          begin @countrenew = @countrenew + 1 end
        elsif rev.policypremiumtransaction.transaction_type == "Endorse"
          begin @revenueendorse = @revenueendorse + revenue end
          @premiumendorse = @premiumendorse + begin rev.policypremiumtransaction.total_premium rescue 0 end
          begin @countendorse = @countendorse + 1 end
        elsif rev.policypremiumtransaction.transaction_type == "Cancel"
          begin @revenuecancel = @revenuecancel + revenue end
          @premiumcancel = @premiumcancel + begin rev.policypremiumtransaction.total_premium rescue 0 end
          begin  @countcancel = @countcancel + 1 end
        elsif rev.policypremiumtransaction.transaction_type == "Reinstate"
          begin @revenuereinstate = @revenuereinstate + revenue end
          @premiumreinstate = @premiumreinstate + begin rev.policypremiumtransaction.total_premium rescue 0 end
          begin @countreinstate = @countreinstate + 1 end
        elsif rev.policypremiumtransaction.transaction_type == "Return Premium"
          begin @revenuereturn = @revenuereturn + revenue   end
          @premiumreturn = @premiumreturn + begin rev.policypremiumtransaction.total_premium rescue 0 end
          begin @countreturn = @countreturn + 1   end


        end
      else

      end

    end

    if !@unearned.nil?
      @unearned.each do |rev|
        unearned = 0
        if rev.trans_type == "Credit"
          unearned= rev.amount
        else
          unearned = (rev.amount * -1)
        end

        @unearnedtotal =  @unearnedtotal  + unearned
        @premiumtotal = @premiumtotal + rev.policypremiumtransaction.total_premium
        @counttotal = @counttotal + 1

        if !rev.policypremiumtransaction.nil?
          if rev.policypremiumtransaction.reconciled != 'Yes'
            if rev.policypremiumtransaction.transaction_type == "New"
              begin @unearnednew =  @unearnednew + unearned end
              begin @premiumnew = @premiumnew + rev.policypremiumtransaction.total_premium   end
              begin @countnew = @countnew + 1 end
            elsif rev.policypremiumtransaction.transaction_type == "Renew"
              begin @unearnedrenew =  @unearnedrenew + unearned  end
              begin @premiumrenew = @premiumrenew + rev.policypremiumtransaction.total_premium end
              begin @countrenew = @countrenew + 1 end
            elsif rev.policypremiumtransaction.transaction_type == "Endorse"
              begin @unearnedendorse = @unearnedendorse + unearned end
              begin @premiumendorse = @premiumendorse + rev.policypremiumtransaction.total_premium end
              begin @countendorse = @countendorse + 1  end
            elsif rev.policypremiumtransaction.transaction_type == "Cancel"
              begin @unearnedcancel = @unearnedcancel + unearned end
              begin @premiumcancel = @premiumcancel + rev.policypremiumtransaction.total_premium end
              begin  @countcancel = @countcancel + 1 end
            elsif rev.policypremiumtransaction.transaction_type == "Reinstate"
              begin @unearnedreinstate = @unearnedreinstate + unearned end
              begin @premiumreinstate = @premiumreinstate + rev.policypremiumtransaction.total_premium end
              begin @countreinstate = @countreinstate + 1    end
            elsif rev.policypremiumtransaction.transaction_type == "Return Premium"
              begin @unearnedreturn = @unearnedreturn + unearned end
              begin @premiumreturn = @premiumreturn + rev.policypremiumtransaction.total_premium end
              begin @countreturn = @countreturn + 1 end
            end
          end
        end
      end
    end

    @commissionexp.each do |exp|
      expense = 0
      if exp.trans_type == "Credit"
        expense= exp.amount
      else
        expense = (exp.amount * -1)
      end

      @expensetotal = @expensetotal + expense
      if !exp.policypremiumtransaction.nil?
        if exp.policypremiumtransaction.transaction_type == "New" or exp.policypremiumtransaction.transaction_type == "Renew"
          @expensenew =  @expensenew + expense
        elsif exp.policypremiumtransaction.transaction_type == "Endorse"
          @expenseendorse = @expenseendorse + expense
        elsif exp.policypremiumtransaction.transaction_type == "Cancel"
          @expensecancel = @expensecancel + expense
        elsif exp.policypremiumtransaction.transaction_type == "Reinstate"
          @expensereinstate = @expensereinstate + expense
        elsif exp.policypremiumtransaction.transaction_type == "Return Premium"
          @expensereturn = @expensereturn + expense

        end
      end

    end

    respond_to do |format|

      format.pdf do
        datetime = DateTime.now

        pdf = CommissionPdf.new(@commissionrev,@commissionexp, @revenuetotal, @revenuenew, @revenueendorse, @revenuecancel,@revenuereinstate, @revenuereturn, @expensetotal, @expensenew, @expenseendorse, @expensecancel,@expensereinstate, @expensereturn, startdate.strftime("%m/%d/%Y"), enddate.strftime("%m/%d/%Y"), @premiumnew, @premiumrenew, @premiumreinstate, @premiumcancel, @premiumendorse, @premiumreturn, @premiumtotal, @unearned, @unearnednew, @unearnedendorse, @unearnedcancel, @unearnedreinstate, @unearnedreturn, @unearnedtotal, @counttotal, @countnew, @countendorse, @countcancel, @countreinstate, @countreturn, @revenuerenew, @unearnedrenew, @countrenew, datetype, current_agent.isgeneralagent)
        send_data pdf.render, filename: "commissionreport_#{datetime.to_s(:number)}",
                  type: "application/pdf",
                  disposition: "inline"
      end
    end
  end


  def surpluslinesreport
    startdate = Date.strptime(params[:start_date].to_s, '%m/%d/%Y')
    enddate   = Date.strptime(params[:end_date].to_s, '%m/%d/%Y')
    @startdate = startdate + 0.hours + 0.minutes
    @enddate   = enddate+23.hours+59.minutes

    @pollist = Policypremiumtransaction.new.surpluslinesreport( @startdate, @enddate, current_agent.generalagency_id )

    render :template => 'reports/fslsoxml.xml.builder', :layout => false
  end


  def surpluslinesreportauto
    startdate = Date.strptime(params[:start_date].to_s, '%m/%d/%Y')
    enddate   = Date.strptime(params[:end_date].to_s, '%m/%d/%Y')
    startdate = startdate + 0.hours + 0.minutes
    enddate   = enddate + 23.hours + 59.minutes

    s = self.fslsosubmit( startdate, enddate, true )

    render text: s, content_type: 'text/html'
  end


  def fslsosubmit( startdate, enddate, manual )
    success = false
    submissionNo = ''

    begin
      ga = current_agent.generalagency_id
    rescue
      ga = 1
    end
    @pollist = Policypremiumtransaction.new.surpluslinesreport( startdate, enddate, ga )
    @startdate = startdate
    @enddate   = enddate

    if @pollist.size == 0
      s = "No premium transactions for the given period"
    else
      xml = render_to_string :template => 'reports/fslsoxml.xml.builder', :layout => false
      #puts xml

      xml64 = Base64.encode64( xml )

      requestXml = '<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Header>
    <AuthenticationHeader xmlns="http://fslso.com/BatchFiling">
      <UserName>l060903</UserName>
      <APIKey>gic4690</APIKey>
    </AuthenticationHeader>
  </soap:Header>
  <soap:Body>
    <WebservicesBatchUpload xmlns="http://fslso.com/BatchFiling">
      <strWSUserName>l060903</strWSUserName>
      <strWSPassword>gic4690</strWSPassword>
      <strComments>BindLink File Submission ' + startdate.to_s + '</strComments>
      <FileStream>' + xml64 + '</FileStream>
      <FileName>BindLink.xml</FileName>
    </WebservicesBatchUpload>
  </soap:Body>
</soap:Envelope>'

#puts Rails.configuration.fslsourl
      uri = URI.parse(Rails.configuration.fslsourl)
      #uri = URI.parse('http://sliptest.fslso.com/webservice/fslsobatchfiling.asmx')
      http = Net::HTTP.new(uri.host, uri.port)

      request = Net::HTTP::Post.new(uri.request_uri)
      #request = Net::HTTP::Get.new(uri.request_uri)

      request.body = requestXml

      request["Content-Type"] = "text/xml; charset=utf-8"

      #puts '-------------'
      #puts request.body
      #puts '-------------'

      response = http.request(request)

      #puts '-------------'
      #puts response.code
      #puts response.body
      #puts '-------------'

      s = response.body
      doc = Nokogiri::XML( response.body )
      doc.remove_namespaces!
      statusMessage = doc.at_css('StatusMessage')
      if !statusMessage.nil?
        s = statusMessage.content
        #s = 'Method call successful.'
        if s == 'Method call successful.'
          success = true
          submissionNo = doc.at_css('SubmissionNumber').content
          if manual
            shtm = "<br/><span style=\"font: 16px arial; color: green\">Submission of Surplus Lines successful!
                    <br/>
                    <br/><span style=\"font-size: 14px; color: black\">Submission Number: #{submissionNo}</span></span>"
          end
          s += " Submission Number: #{submissionNo}"
        else
          if s == 'Method call failed. File does not pass schema validation.'
            requestXml = '<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Header>
    <AuthenticationHeader xmlns="http://fslso.com/BatchFiling">
      <UserName>l060903</UserName>
      <APIKey>gic4690</APIKey>
    </AuthenticationHeader>
  </soap:Header>
  <soap:Body>
    <ValidateAgainstSchema xmlns="http://fslso.com/BatchFiling">
      <FileStream>' + xml64 + '</FileStream>
    </ValidateAgainstSchema>
  </soap:Body>
</soap:Envelope>'
            request.body = requestXml
            response = http.request(request)

            #puts '-------------'
            #puts request.body
            #puts '-------------'
            #puts response.code
            #puts response.body

            s2 = response.body
            doc = Nokogiri::XML( response.body )
            doc.remove_namespaces!
            statusMessage = doc.at_css('StatusMessage')
            if !statusMessage.nil?
              s2 = statusMessage.content
              if s2 == 'File failed schema validation.'
                schemaErrors = doc.at_css('SchemaErrors')
                if !schemaErrors.nil?
                  s2 = Base64.decode64(schemaErrors.content)
                  #puts '-------------'
                  #puts s2
                  if manual
                    shtm = '<br>' + s2.gsub( '</Error>', "" ).gsub( '<Error>', "<br>" )
                  end
                  s2 = ' ' + s2.gsub( '</Error>', "" ).gsub( '<Error>', "; " )
                end
              end
            end
            if manual
              shtm = s + " " + shtm
            end
            s += " " + s2
          elsif s == 'Method call failed.'
            requestXml = '<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Header>
    <AuthenticationHeader xmlns="http://fslso.com/BatchFiling">
      <UserName>l060903</UserName>
      <APIKey>gic4690</APIKey>
    </AuthenticationHeader>
  </soap:Header>
  <soap:Body>
    <VerifyCredentials xmlns="http://fslso.com/BatchFiling">
      <strWSUserName>l060903</strWSUserName>
      <strWSPassword>gic4690</strWSPassword>
    </VerifyCredentials>
  </soap:Body>
</soap:Envelope>'

            request.body = requestXml
            response = http.request(request)

            #puts '-------------'
            #puts request.body
            #puts '-------------'
            #puts response.code
            #puts response.body

            s2 = response.body
            doc = Nokogiri::XML( response.body )
            doc.remove_namespaces!
            statusMessage = doc.at_css('StatusMessage')
            if !statusMessage.nil?
              s2 = statusMessage.content
            end
            s += " " + s2
            if manual
              shtm = s
            end
          end
          if manual
            shtm = "<br/><span style=\"font: 16px arial; color: red\">Sorry, submission of Surplus Lines failed.<br/><br/><span style=\"font-size: 14px; color: black\">Message received from API: " + shtm + "</span></span>"
          end
        end
      end

      FslsoAuto.new.addlog( startdate, enddate, success, manual, s, submissionNo )

      if manual
        s = shtm
      end
    end

    s
  end


  def policylistingreport
    startdate =  Date.strptime(params[:start_date].to_s, '%m/%d/%Y')
    enddate =Date.strptime(params[:end_date].to_s, '%m/%d/%Y')
    startdate =startdate + 0.hours + 0.minutes
    enddate= enddate+23.hours+59.minutes
    if current_agent.isgeneralagent == "Retail"
      agency = current_agent.agency_id
      @pollist = Policypremiumtransaction.joins("JOIN policies ON policies.id = policypremiumtransactions.policy_id ").where("policypremiumtransactions.created_at >= ? AND policypremiumtransactions.created_at <= ? AND policies.agency_id = ? ", startdate, enddate, agency)

    else
      agency = current_agent.generalagency_id
      @pollist = Policypremiumtransaction.joins("JOIN policies ON policies.id = policypremiumtransactions.policy_id ").where("policypremiumtransactions.created_at >= ? AND policypremiumtransactions.created_at <= ? AND policies.generalagency_id = ? ", startdate, enddate, agency)

    end

    respond_to do |format|

      format.pdf do
        datetime = DateTime.now
        pdf = PolicylistingPdf.new(@pollist, startdate.strftime("%m/%d/%Y"), enddate.strftime("%m/%d/%Y"))
        send_data pdf.render, filename:  "BindlinkPolicyListing_#{datetime.to_s(:number)}",
                  type: "application/pdf",
                  disposition: "inline"
      end
    end
  end


  def accountingreport
    startdate = Date.strptime(params[:start_date].to_s, '%m/%d/%Y')
    enddate   = Date.strptime(params[:end_date].to_s, '%m/%d/%Y')

    startdate = startdate + 0.hours + 0.minutes
    enddate   = enddate+23.hours+59.minutes
    
    if current_agent.isgeneralagent == "Retail"
      agency = current_agent.agency_id
    else
      agency = current_agent.generalagency_id
    end

    @transactions = Accountingtransaction.joins(:policy).where("accountingtransactions.created_at >= ? AND accountingtransactions.created_at <= ? AND policies.agency_id = ? ", startdate, enddate, agency)

    respond_to do |format|
      format.pdf do
        datetime = DateTime.now
        pdf = AccountingPdf.new(@transactions, startdate.strftime("%m/%d/%Y"), enddate.strftime("%m/%d/%Y"))
        send_data pdf.render, filename:  "BindlinkAccountingTransaction_#{datetime.to_s(:number)}",
                  type: "application/pdf",
                  disposition: "inline"
      end
    end
  end


  def feesreport
    @fee = Feetransaction.new.feereport(current_agent.generalagency_id)
    respond_to do |format|

      format.pdf do
        datetime = DateTime.now
        pdf = CashreportPdf.new(@cash, @cashtotal)
        send_data pdf.render, filename: "BindlinkCashReport_#{datetime.to_s(:number)}",
                  type: "application/pdf",

                  disposition: "inline"
      end
    end
  end


  def cashreport
    startdate =  Date.strptime(params[:start_date].to_s, '%m/%d/%Y')
    enddate =Date.strptime(params[:end_date].to_s, '%m/%d/%Y')
    startdate =startdate + 0.hours + 0.minutes
    enddate= enddate+23.hours+59.minutes

    if current_agent.isgeneralagent == "Retail"
      agency = current_agent.agency_id
      @cash = Cashtransaction.joins("JOIN policies  ON  policies.id = cashtransactions.policy_id").where("cashtransactions.created_at >= ? AND cashtransactions.created_at  <= ?  AND policies.agency_id =?", startdate, enddate,  agency).order("created_at ASC")

    else
      agency = current_agent.generalagency_id
      @cash = Cashtransaction.joins("JOIN policies  ON  policies.id = cashtransactions.policy_id").where("cashtransactions.created_at >= ? AND cashtransactions.created_at  <= ? AND cashtransactions.transaction_type <> 'Void'  AND cashtransactions.transaction_type <> 'Commission Payable' AND cashtransactions.void_flag is null  AND policies.generalagency_id =?", startdate, enddate,  agency).order("created_at ASC")

    end
    @cashtotal = 0

    @cash.each do |csh|
      if !csh.cash_amount.nil?
        @cashtotal = @cashtotal + csh.cash_amount
      end

    end


    respond_to do |format|

      format.pdf do
        datetime = DateTime.now

        pdf = CashreportPdf.new(@cash, @cashtotal,startdate.strftime("%m/%d/%Y"), enddate.strftime("%m/%d/%Y"))
        send_data pdf.render, filename: "BindlinkCashReport_#{datetime.to_s(:number)}",
                  type: "application/pdf",
                  disposition: "inline"
      end
    end
  end


  def agingreport
    Delayed::Job.enqueue Createagingreport.new(current_agent.email)

    respond_to do |format|
       format.js
    end
  end


  def agingreportpdf
    agencyid = 1
    atype    =  "GA"

    @invoices30 = Report.new.agingreport(agencyid, 0,  30, atype)
    @invoices60 = Report.new.agingreport(agencyid, 31, 60, atype)
    @invoices90 = Report.new.agingreport(agencyid, 61, 90, atype)
    @invoicesover = Report.new.agingreport(agencyid, 91, 5000, atype)

    pdf = AgingreportPdf.new(@invoices30, @invoices60, @invoices90, @invoicesover)

    send_data pdf.render, filename: "agingreport.pdf",
                  type: "application/pdf",
                  disposition: "attachment"
  end


  def agingreportxls
    agencyid = 1
    atype    =  "GA"

    @invoices30 = Report.new.agingreport(agencyid, 0,  30, atype)
    @invoices60 = Report.new.agingreport(agencyid, 31, 60, atype)
    @invoices90 = Report.new.agingreport(agencyid, 61, 90, atype)
    @invoicesover = Report.new.agingreport(agencyid, 91, 5000, atype)

    require 'spreadsheet'

    # Open source spreadsheet
    workbook = Spreadsheet::Workbook.new
    sheet = workbook.create_worksheet :name => 'Report'

    sheet.column(0).width = 45 # Producing Agency
    sheet.column(1).width = 20 # Policy
    sheet.column(2).width = 12 # Due On
    sheet.column(3).width = 45 # Carrier
    sheet.column(4).width = 13 # Balance
    sheet.column(5).width = 10 # Status
    sheet.column(6).width = 18 # Days Outstanding

    money_format = Spreadsheet::Format.new :number_format => "$#,##0.00"
    sheet.column(4).default_format = money_format

    bold18 = Spreadsheet::Format.new :weight => :bold, :size => 18
    sheet.row( 0 ).push 'Invoice Aging Report'
    sheet.row( 0 ).set_format( 0, bold18 )
    sheet.row( 0 ).height = 21

    bal = 0
    bal += agingreportxlssection sheet, @invoices30, '0 to 30 Days'
    bal += agingreportxlssection sheet, @invoices60, '31 to 60 Days'
    bal += agingreportxlssection sheet, @invoices90, '61 to 90 Days'
    bal += agingreportxlssection sheet, @invoicesover, 'Over 90 Days'

    i = sheet.last_row_index + 1
    money_bold = Spreadsheet::Format.new :weight => :bold, :number_format => "$#,##0.00"
    sheet.row( i ).default_format = money_bold
    sheet.row( i ).push 'Grand Total', bal

    filename = 'agingreport.xls'
    workbook.write( filename )

    send_file filename,
                  type: "application/pdf",
                  disposition: "attachment"
  end


  def agingreportxlssection( sheet, inv, name )
    bal = 0

    if !inv.empty? then
      i = sheet.last_row_index
      
      bold = Spreadsheet::Format.new :weight => :bold
      sheet.row( i+=2 ).push name
      sheet.row( i ).set_format( 0, bold )
      sheet.row( i ).height = 12
  
      sheet.row( i+=1 ).default_format = bold
      sheet.row( i ).height = 12
      sheet.row( i ).push 'Producing Agency', 'Policy', 'Due On', 'Carrier', 'Balance', 'Status', 'Days Outstanding'

      inv.each do |inv|
        bal = bal + inv.outstandingbalance
        agency_name = ""
        unless inv.policypremiumtransaction.policy.producingagency.nil?
          agency_name = inv.policypremiumtransaction.policy.producingagency.agency_name
        end
        sheet.row( i+=1 ).push agency_name,
              inv.policypremiumtransaction.policy.policy_number,
              inv.due_on,
              inv.policypremiumtransaction.policy.carrier.carrier_name,
              inv.outstandingbalance,
              inv.policypremiumtransaction.policy.status,
              inv.invoiceage
      end
    end

    bal
  end


  def returnreport
    Delayed::Job.enqueue Createreturnreport.new( current_agent.email, getstartdate( '01/01/2017' ), getenddate( Date.today.strftime( '%m/%d/%Y' ) ) )

    respond_to do |format|

      format.js

    end
  end


  def returnreportpdf
    agencyid = 1

    returnpremiums = Cashtransaction.new.policieswithreturn( agencyid, getstartdate( '01/01/2017' ), getenddate( Date.today.strftime( '%m/%d/%Y' ) ) )

    pdf = ReturnpremiumreportPdf.new(returnpremiums)

    send_data pdf.render, filename: "returnreport.pdf",
                  type: "application/pdf",
                  disposition: "attachment"
  end


  def returnreportinvoices
    @invoices = Invoice.joins("\n\
        JOIN policypremiumtransactions ppt2 ON invoices.policypremiumtransaction_id = ppt2.id \n\
        JOIN ( \n\
            SELECT p.id \n\
            FROM policies p
              JOIN policypremiumtransactions ppt ON ppt.policy_id = p.id \n\
              JOIN invoices i ON i.policypremiumtransaction_id = ppt.id \n\
              LEFT JOIN ( SELECT invoice_id, SUM( cash_amount ) amount FROM cashtransactions GROUP BY invoice_id \n\
                      ) c ON c.invoice_id = i.id  \n\
            WHERE p.generalagency_id = 1 AND p.effective_date BETWEEN '" + getstartdate( '01/01/2017' ).to_s(:db) + "' AND '" + getenddate( Date.today.strftime( '%m/%d/%Y' ) ).to_s(:db) + "' \n\
            GROUP BY p.id \n\
            HAVING COALESCE( SUM( i.total_billed ), 0 ) - COALESCE( SUM( c.amount ), 0 ) > 0.01 \n\
          ) p2 ON p2.id = ppt2.policy_id ").order("p2.id")
    pdf = CombinePDF.new("electronicpayment.pdf")
    f = true
    @invoices.each do |inv|
      if inv.outstandingbalance.abs > 0.1 
        if f then
          pdf = CombinePDF.parse(InvoicePdf.new(inv).render)
          f = false
        else
          pdf << CombinePDF.parse(InvoicePdf.new(inv).render)
        end
      end
    end

    if f then
      s = "No invoices for selected date period"
      render text: s, content_type: 'text/html'
    else
      datetime = DateTime.now
      send_data pdf.to_pdf, filename: "invoices_batch_print_#{datetime.to_s(:number)}.pdf",
                    type: "application/pdf",
                    disposition: "inline"
    end
  end


  def getstartdate def_date
    begin
      startdate = Date.strptime( params[:start_date].to_s, '%m/%d/%Y' )
    rescue
      startdate = Date.strptime( def_date, '%m/%d/%Y')
    end
    startdate = startdate + 0.hours + 0.minutes
    startdate
  end


  def getenddate def_date
    begin
      enddate   = Date.strptime( params[:end_date].to_s, '%m/%d/%Y' )
    rescue
      enddate   = Date.strptime( def_date, '%m/%d/%Y')
    end
    enddate   = enddate + 23.hours + 59.minutes
    enddate
  end


  def expirationreport
    if current_agent.isgeneralagent == "Retail"
      agencyid = current_agent.agency_id
    else
      agencyid = current_agent.generalagency_id
    end

    startdate =  Date.strptime(params[:start_date].to_s, '%m/%d/%Y')
    enddate =Date.strptime(params[:end_date].to_s, '%m/%d/%Y')
    lobid = params[:lobid]
    carrierid = params[:carrierid]
    startdate =startdate + 0.hours + 0.minutes
    enddate= enddate+23.hours+59.minutes

    @expiring = Report.new.expiringreport( agencyid, startdate, enddate, current_agent.isgeneralagent, lobid, carrierid )

    respond_to do |format|
      format.pdf do
        datetime = DateTime.now
        pdf = ExpiringreportPdf.new( @expiring, startdate, enddate, current_agent.isgeneralagent, lobid, carrierid )
        send_data pdf.render, filename: "BindlinkExpiringReport_#{datetime.to_s(:number)}",
                  type: "application/pdf",
                  disposition: "inline"
      end
    end
  end


  def renewalreport
    if current_agent.isgeneralagent == "Retail"
      agencyid = current_agent.agency_id
    else
      agencyid = current_agent.generalagency_id
    end

    startdate = getstartdate Date.today.strftime( '%m/%d/%Y' )
    enddate = getenddate( ( Date.today + 25.day ).strftime( '%m/%d/%Y' ) ).midnight
    lobid = params[:lobid]

    r = Report.new.renewalreport( startdate, enddate, lobid )

    if lobid != "all"
      lob = Lineofbusiness.find(lobid)
      lob = lob.line_name
    else
      lob = "All"
    end

    respond_to do |format|
      format.pdf do
        datetime = DateTime.now
        pdf = RenewalReportPdf.new( r, startdate, enddate, lob )
        send_data pdf.render, filename: "BindlinkRenewalReport_#{datetime.to_s(:number)}",
                  type: "application/pdf",
                  disposition: "inline"
      end
    end
  end


  def incomereport
    if current_agent.isgeneralagent == "Retail"
      agencyid = current_agent.agency_id
    else
      agencyid = current_agent.generalagency_id
    end

    startdate =  Date.strptime(params[:start_date].to_s, '%m/%d/%Y')
    enddate =Date.strptime(params[:end_date].to_s, '%m/%d/%Y')
    carrierid = params[:carrierid]
    startdate =startdate + 0.hours + 0.minutes
    enddate= enddate+23.hours+59.minutes

    @expiring = Report.new

    @expiring = @expiring.expiringreport(agencyid, startdate, enddate, current_agent.isgeneralagent, lobid )

    respond_to do |format|


      format.pdf do
        datetime = DateTime.now
        pdf = ExpiringreportPdf.new(@expiring, startdate, enddate,current_agent.isgeneralagent, lobid)
        send_data pdf.render, filename: "BindlinkExpiringReport_#{datetime.to_s(:number)}",
                  type: "application/pdf",
                  disposition: "inline"
      end
    end
  end


  def producerrpt
    sql = "
      SELECT pa.id, pa.agency_name
          , COALESCE( pp1.p_count, 0 ) AS policy_count
          , COALESCE( s.s_count, 0 ) AS submission_count
          , COALESCE( pp2.premium, 0 ) AS active_premium
          , COALESCE( pp3.balance, 0 ) AS balance_open
      FROM producingagencies pa
        LEFT JOIN ( SELECT COUNT( DISTINCT p.id ) AS p_count, p.producingagency_id
                    FROM policies p
                    WHERE p.status = 'Active' AND p.effective_date >= date_trunc('year', now())
                    GROUP BY p.producingagency_id ) pp1 ON pp1.producingagency_id = pa.id
        LEFT JOIN ( SELECT COUNT( id ) AS s_count, producingagency_id
                    FROM submissions
                    WHERE created_at >= date_trunc('year', now())
                    GROUP BY producingagency_id ) s ON s.producingagency_id = pa.id
        LEFT JOIN ( SELECT SUM( ppt2.total_premium ) AS premium, p2.producingagency_id
                    FROM policies p2
                      JOIN policypremiumtransactions ppt2 ON p2.id = ppt2.policy_id AND ppt2.transaction_type IN ( 'New', 'Endorse', 'Return Premium', 'Renew', 'Adjust' )
                    WHERE p2.status = 'Active'
                    GROUP BY p2.producingagency_id ) pp2 ON pp2.producingagency_id = pa.id
        LEFT JOIN ( SELECT COALESCE( SUM( i.total_billed ), 0 ) - COALESCE( SUM( ct.amount ), 0 ) AS balance, p3.producingagency_id
                    FROM policies p3
                      JOIN policypremiumtransactions ppt3 ON p3.id = ppt3.policy_id
                      JOIN invoices i ON ppt3.id = i.policypremiumtransaction_id
                      LEFT JOIN ( SELECT invoice_id, SUM( cash_amount ) amount FROM cashtransactions GROUP BY invoice_id
                                ) ct ON ct.invoice_id = i.id
                    WHERE p3.status = 'Active'
                    GROUP BY p3.producingagency_id ) pp3 ON pp3.producingagency_id = pa.id
      WHERE pa.status = 'Active'
      ORDER BY pa.agency_name
    "
    producers = ActiveRecord::Base.connection.exec_query sql

    pdf = ProducerrptPdf.new( producers )

    send_data pdf.render, filename: "Producing Agency Report.pdf",
                  type: "application/pdf",
                  disposition: "inline"
  end
end
