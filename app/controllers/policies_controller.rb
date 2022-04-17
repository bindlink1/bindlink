class PoliciesController < ApplicationController

  layout 'applicationfunctional'
  before_filter :login_marshall
  before_filter :only => ["renew", "cancel"] do |bf|
    policy = Policy.find(params[:id])

    if policy.status == "Renewed"
      redirect_to  policy_path
    end
  end

  before_filter :only => ["show", "edit", "destroy","update", "renew", "endorse", "endorsetransactions", "cancel", "canceltransactions","paycarrier", "paycarriertransactions","agentofrecordchange", "updateagentofrecord"] do |bf|
    policy = Policy.find(params[:id])
    if current_agent.isgeneralagent =="GA"
      bf.permission_marshall(policy.generalagency_id)
    else
      bf.permission_marshall(policy.agency_id)
    end
  end

  respond_to :html, :json, :xml
  set_tab :policy
  set_tab :newpolicy, :sidenav, :only => %w(new)
  set_tab :newpolicy, :sidenav, :only => %w(newpolicyga)
  set_tab :policyhome, :sidenav, :only => %w(show)
  set_tab :policyhome, :sidenav, :only => %w(index)


  def flag_policy
    @policy = Policy.find(params[:id])

    respond_to do |format|
      format.js
    end
  end


  def flag_policy_process
    @policy = Policy.find(params[:id])
    @policy.policy_flag = true
    @policy.flag_note = params[:policy][:flag_note]
    @policy.save

    respond_to do |format|
      format.js
    end
  end


  def flag_policy_remove
    @policy = Policy.find(params[:id])
    @policy.policy_flag = false
    @policy.flag_note = ""
    @policy.save

    respond_to do |format|
      format.js
    end
  end


  def destroy
    @policy = Policy.find(params[:id])
    @policy.destroy
    redirect_to '/welcome'
  end


  def autoxml
    @policy = Policy.find(params[:id])

    #respond_to do |format|
    # format.xml {render :layout=>false}

    #end
    render :template => 'policies/autoxml.xml.builder', :layout => false
  end


  def newpolicylanding
    @producingagencies = Producingagency.find_all_by_generalagency_id(current_agent.generalagency_id)

    respond_to do |format|
      format.html # _new.html.erb
      format.json { render json: @policy }
    end
  end


  def new
    @policy = Policy.new
    @client = Client.find(params[:client_id])
    @policy.policypremiumtransactions.build do |ppt|
      ppt.feetransactions.build
    end
    initpoldropdowns
    respond_to do |format|
      format.html # _new.html.erb
      format.json { render json: @policy }
    end
  end


  def edit
    @policy = Policy.find(params[:id])
    initpoldropdowns
    @line = Lineofbusiness.find_all_by_agency_id(current_agent.agency_id)
    @policy.effective_date=  @policy.effective_date.strftime("%m/%d/%Y")
    @policy.expiration_date=  @policy.expiration_date.strftime("%m/%d/%Y")
  end


  def update
    @policy = Policy.find(params[:id])
    old_cond_comm = @policy.producercommrate

    #this is here to translate the date format used in the application to the format
    #used in the DB
    @effdate = Date.new
    @expdate = Date.new

    @effdate = Date.strptime(params[:policy][:effective_date].to_s, '%m/%d/%Y')
    @expdate = Date.strptime(params[:policy][:expiration_date].to_s, '%m/%d/%Y')

    params[:policy][:effective_date] = @effdate
    params[:policy][:expiration_date] = @expdate

    respond_to do |format|
      if @policy.update_attributes(params[:policy])
        @policyforview = Policy.find(params[:id])

        new_cond_comm = @policyforview.producercommrate
        if old_cond_comm != new_cond_comm
          @policyforview.cond_comm_producer = old_cond_comm
          @policyforview.updatecommission(new_cond_comm)
        end

        $currentpolicy = @policy.id

        format.js
      end
    end
  end


  def create
    # this is removing the $ signs from the values

    params[:policy][:policypremiumtransactions_attributes]["0"][:total_premium] = (params[:policy][:policypremiumtransactions_attributes]["0"][:total_premium]).gsub( /[^\d.]/,'').to_f
    params[:policy][:policypremiumtransactions_attributes]["0"][:base_premium] =  (params[:policy][:policypremiumtransactions_attributes]["0"][:base_premium]).gsub( /[^\d.]/,'').to_f
    params[:policy][:policypremiumtransactions_attributes]["0"][:complexfees] =   (params[:policy][:policypremiumtransactions_attributes]["0"][:complexfees]).gsub( /[^\d.]/,'').to_f
    params[:policy][:policypremiumtransactions_attributes]["0"][:fees] =          (params[:policy][:policypremiumtransactions_attributes]["0"][:fees]).gsub( /[^\d.]/,'').to_f
    params[:policy][:policypremiumtransactions_attributes]["0"][:transaction_effective_date] =  Date.strptime(params[:policy][:effective_date].to_s, '%m/%d/%Y')
    begin
      params[:policy][:policypremiumtransactions_attributes]["0"][:feetransactions_attributes].each_with_index do |a, index|
        params[:policy][:policypremiumtransactions_attributes]["0"][:feetransactions_attributes][index.to_s][:fee_amount] = (params[:policy][:policypremiumtransactions_attributes]["0"][:feetransactions_attributes][index.to_s][:fee_amount]).gsub( /[^\d.]/,'').to_f
      end
    rescue
    end

    if params[:policy][:is_renewal] == "true"
      params[:policy][:policypremiumtransactions_attributes]["0"][:transaction_type]  = "Renew"
    elsif  params[:policy][:is_renewal] == "false"
      params[:policy][:policypremiumtransactions_attributes]["0"][:transaction_type]  = "New"
    end

    #now that we have converted the $ signs we can create a new policy with the parameters

    @policy = Policy.new(params[:policy])

    #this is here to translate the date format used in the application to the format
    #used in the DB
    effdate = Date.new
    expdate = Date.new

    effdate = Date.strptime(params[:policy][:effective_date].to_s, '%m/%d/%Y')
    expdate = Date.strptime(params[:policy][:expiration_date].to_s, '%m/%d/%Y')

    @policy.effective_date = effdate
    @policy.expiration_date = expdate

    @policy.bindpolicy(current_agent.id)

    respond_to do |format|
      # todo explain why I am setting these session variables
      #$currentpolicy = @policy.id
      #$currentcarrier = @policy.carrier_id

      #for invoice in aftercreate
      @ppt = Policypremiumtransaction.find_all_by_policy_id(@policy.id)
      @invoice = Invoice.find_all_by_policypremiumtransaction_id(@ppt[0].id)

      format.js
    end
  end


  def createrenew
    # this is removing the $ signs from the values

    params[:policy][:policypremiumtransactions_attributes]["0"][:total_premium] = (params[:policy][:policypremiumtransactions_attributes]["0"][:total_premium]).gsub( /[^\d.]/,'').to_f
    params[:policy][:policypremiumtransactions_attributes]["0"][:base_premium] =  (params[:policy][:policypremiumtransactions_attributes]["0"][:base_premium]).gsub( /[^\d.]/,'').to_f
    params[:policy][:policypremiumtransactions_attributes]["0"][:complexfees] =   (params[:policy][:policypremiumtransactions_attributes]["0"][:complexfees]).gsub( /[^\d.]/,'').to_f
    params[:policy][:policypremiumtransactions_attributes]["0"][:fees] =          (params[:policy][:policypremiumtransactions_attributes]["0"][:fees]).gsub( /[^\d.]/,'').to_f
    params[:policy][:policypremiumtransactions_attributes]["0"][:transaction_effective_date] =  Date.strptime(params[:policy][:effective_date].to_s, '%m/%d/%Y')
    begin
      params[:policy][:policypremiumtransactions_attributes]["0"][:feetransactions_attributes].each_with_index do |a, index|
        params[:policy][:policypremiumtransactions_attributes]["0"][:feetransactions_attributes][index.to_s][:fee_amount] = (params[:policy][:policypremiumtransactions_attributes]["0"][:feetransactions_attributes][index.to_s][:fee_amount]).gsub( /[^\d.]/,'').to_f
      end
    rescue
    end

    if params[:policy][:is_renewal]
      params[:policy][:policypremiumtransactions_attributes]["0"][:transaction_type]  = "Renew"
    elsif  !params[:policy][:is_renewal]
      params[:policy][:policypremiumtransactions_attributes]["0"][:transaction_type]  = "New"
    end

    #now that we have converted the $ signs we can create a new policy with the parameters

    @policy = Policy.new(params[:policy])

    # getting
    @carrierlob = Carrierlob.where("carrier_id =? AND lineofbusiness_id =?", @policy.carrier_id,@policy.lineofbusiness_id )
    @commission = Lobcommission.where("carrierlob_id =? AND state = ?", @carrierlob[0].id, @policy.state )

    @policy.payment_type_id = @commission[0].billing_type

    # todo: I am passing the value "new" into policypremiumtransactions via a hidden field in the form

    if current_agent.isgeneralagent == "Retail"
      @policy.agency_id = current_agent.agency_id
    else
      @policy.generalagency_id = current_agent.generalagency_id
    end

    if !params[:policy][:quote_id].nil?
      @quote = Quote.find(params[:policy][:quote_id])
      @quote.bindquote
    end

    #this is here to translate the date format used in the application to the format
    #used in the DB
    @effdate = Date.new
    @expdate = Date.new

    @effdate = Date.strptime(params[:policy][:effective_date].to_s, '%m/%d/%Y')
    @expdate = Date.strptime(params[:policy][:expiration_date].to_s, '%m/%d/%Y')

    @policy.effective_date = @effdate
    @policy.expiration_date = @expdate

    #since this is a new policy, I am setting it to active
    @policy.status = "Active"

    # Note: accounting transactions are being recorded in policypremiumtransactions model since this is a
    #nested model form
    respond_to do |format|
      if @policy.save
        # todo explain why I am setting these session variables
        $currentpolicy = @policy.id
        $currentcarrier = @policy.carrier_id

        #for invoice in aftercreate
        @ppt = Policypremiumtransaction.find_all_by_policy_id(@policy.id)
        @invoice = Invoice.find_all_by_policypremiumtransaction_id(@ppt[0].id)

        #mark old policy as renewed
        @policyold = Policy.find(@policy.originalpolicy_id)

        @policyold.status = "Renewed"

        @policyold.save

        format.html { redirect_to(@policy)}
      else
        format.html { redirect_to(@policy)}
        format.html { render action: "new" }
        format.json { render json: @policy.errors, status: :unprocessable_entity }
      end
    end
  end


  def index
    if current_agent.isgeneralagent == "Retail"
      agencyid = current_agent.agency_id
      agencyt = "Retail"
    else
      agencyid = current_agent.generalagency_id
      agencyt = "GA"
    end

    respond_to do |format|
      format.html
      format.json { render json: PoliciesDatatable.new(view_context, agencyid, agencyt) }
    end
  end


  def renewal
    respond_to do |format|
      format.json { render json: PoliciesRenewalDatatable.new( view_context, params[:i], params[:type] ) }
    end
  end


  def agedinvoices
    respond_to do |format|
      format.json { render json: AgedInvoicesDatatable.new( view_context, params[:i] ) }
    end
  end


  def show
    @persautopolicy =  AcordXmlPersAutoPolicy.find_by_policy_id(params[:id])
    @policyforview = Policy.find(params[:id])
    @inboundemails = Inboundemail.find_all_by_policy_id(params[:id])


    @tasks = Task.where("status is null  AND mastertask_id is null").order("created_at DESC").find_all_by_policy_id(params[:id])
    @policynote = Note.new
    @notesforview = Note.order("created_at DESC").find_all_by_policy_id(@policyforview.id)
    if @policyforview.status == "Cancelled"
      @styleclass = "cancelstep"
      @cancelbuttondisabled = false

    elsif @policyforview.status == "Renewed"
      @renewalpolicies = Policy.where("originalpolicy_id = ?", @policyforview.id)

    elsif  @policyforview.status == "Active"
      @styleclass = "activestep"
      @cancelbuttondisabled = false
    end

    @pptforview = Policypremiumtransaction.order("id ASC").find_all_by_policy_id(params[:id])

    @invoicesforview = Invoice.order("created_at ASC").find_all_by_policypremiumtransaction_id(@pptforview)

    @documentsforview = Document.where( "policy_id = ?", @policyforview.id ).order("created_at DESC")
    if !@policyforview.quote_id.nil?
      @quotedocumentsforview = Document.find_all_by_quote_id(@policyforview.quote_id)
      if !@policyforview.quote.submission_id.nil?
        @submissiondocumentsforview = Document.find_all_by_submission_id(@policyforview.quote.submission_id)
      end
      @quotenotesforview = Note.order("created_at DESC").find_all_by_quote_id(@policyforview.quote_id)
    end
    @cashhistoryforview = Cashtransaction.find_all_by_policy_id(@policyforview.id)
    @feesforview =  Feetransaction.find_all_by_policypremiumtransaction_id(@pptforview)
    respond_to do |format|
      format.html
      format.xml {render xml:@policyforview}
      format.json {render :json =>{:newpols =>  @policyforview}}
    end
  end


  def flatcancel
    @policy = Policy.find(params[:id])
    @policy.flatcancel
  end


  def cancel
    @policy = Policy.find(params[:id])
    @policypremiumtransactioncancel = @policy.policypremiumtransactions.build

    @carrierlob = Carrierlob.where("carrier_id =? AND lineofbusiness_id =?", @policy.carrier_id,@policy.lineofbusiness_id )
    # @commission = Lobcommission.where("carrierlob_id =? AND state = ?", @carrierlob[0].id, @policy.state )

    @fees = Lobfee.new.getfeesforlob(@policy.lineofbusiness_id, @policy.state)

    @policypremiumtransactioncancel.feetransactions.build
  end

  def canceltransactions

    @policy = Policy.find(params[:id])
    @policy.cancel(params[:policypremiumtransaction], params[:recmoney].to_s)

    respond_to do |format|
      format.js
    end

  end

  def canceltransactionssimple

    @policy = Policy.find(params[:id])
    @policy.cancelsimple(params[:policypremiumtransaction])

    respond_to do |format|
      format.js
    end

  end

  def newpolicyga

    @policy = Policy.new

    if !params[:id].nil?
      @policy.producingagency_id = params[:id]
    end

    @policy.build_namedinsured

    @policy.policypremiumtransactions.build do |ppt|
      ppt.feetransactions.build
    end
    initpoldropdowns
  end



  def renew

    @policyold = Policy.find(params[:id])


    @policy = Policy.new
    basepremiumold = 0
    @policyold.policypremiumtransactions.each do |oldppt|
      begin
        basepremiumold = basepremiumold + oldppt.base_premium
      rescue
      end

    end

    @policy.policypremiumtransactions.build do |ppt|
      ppt.base_premium = basepremiumold
      ppt.feetransactions.build
    end


    @policy.namedinsured_id = @policyold.namedinsured_id
    @policy.client_id = @policyold.client_id
    @policy.policy_number = @policyold.policy_number
    @policy.state = @policyold.state
    @policy.carrier_id = @policyold.carrier_id
    @policy.lineofbusiness_id = @policyold.lineofbusiness_id
    @policy.policy_term = @policyold.policy_term
    @policy.effective_date = @policyold.effective_date
    @policy.expiration_date = @policyold.expiration_date
    @policy.description = @policyold.description
    @policy.is_renewal = true

    @policy.originalpolicy_id = @policyold.id




    #@policypremiumtransactions= Policypremiumtransaction.where("transaction_type='Endorse' AND policy_id = ?", params[:id])
    initpoldropdowns
    @line = Lineofbusiness.find_all_by_agency_id(current_agent.agency_id)

    @policy.producingagency_id = @policyold.producingagency_id




    if @policy.policy_term == "12 Month"
      @policy.effective_date=  @policy.effective_date + 1.year
      @policy.expiration_date=  @policy.expiration_date + 1.year
    elsif  @policy.policy_term == "6 Month"
      @policy.effective_date=  @policy.effective_date + 6.months
      @policy.expiration_date=  @policy.expiration_date + 6.months
    end

    @policy.effective_date=  @policy.effective_date.strftime("%m/%d/%Y")
    @policy.expiration_date=  @policy.expiration_date.strftime("%m/%d/%Y")
    respond_to do |format|

      format.html # _new.html.erb
      format.json { render json: @policynew }
    end
  end

  def returnamountgnome
    #called from a javascript ajax request
    #used to check if return premium is > total policy premium
    @response = params[:totalreturn]

    @policypremium = Policy.find($policyforcancel)

    if @policypremium.annualpremium < @response.to_f
      @gnome = "over"

    else
      @gnome = "ok"

    end

    render :json => @gnome.to_s


  end

  def cancbalance
    #called from a javascript ajax request
    #used to check if Policy has a balance

    @policypremium = Policy.find($policyforcancel)

    if @policypremium.arbalance != 0
      @balance = "balance"
      @balanceamount= @policypremium.arbalance
    else
      @balance = "ok"

    end

    render :json =>{:balance => @balance, :balanceamount =>@balanceamount}


  end


  def updateaftertransaction

    @policyforview = Policy.find(params[:policy_id])
    @pptforview = Policypremiumtransaction.find_all_by_policy_id(params[:policy_id])
    @invoicesforview = Invoice.find_all_by_policypremiumtransaction_id(@pptforview)
    @documentsforview = Document.find_all_by_policy_id(params[:policy_id])
    @cashhistoryforview = Cashtransaction.find_all_by_policy_id(params[:policy_id])
    @feesforview =  Feetransaction.find_all_by_policypremiumtransaction_id(@pptforview)

    if @policyforview.status == "Cancelled"
      @styleclass = "cancelstep"
      @cancelbuttondisabled = false

    elsif @policyforview.status == "Renewed"
      @renewalpolicies = Policy.where("originalpolicy_id = ?", @policyforview.id)

    elsif  @policyforview.status == "Active"
      @styleclass = "activestep"
      @cancelbuttondisabled = false
    end



    @transtype = params[:transtype]
    respond_to do |format|
      format.js
    end
  end

  #todo this will interface with the Carriers model to pull a default # of days to make the invoice due. It would also be good to have
  #a minimum just in case there
  def invoicedue
    #called from a javascript ajax request
    @response = params[:effectivedate]

    @effdate = Date.new

    @effdate = Date.strptime(@response.to_s, '%m/%d/%Y')

    @effdate = @effdate + 10.days

    @effdate =  @effdate.strftime("%m/%d/%Y")

    render :json => @effdate.to_s


  end


  def createclient
    @client = Client.new
    @client = Client.new(params[:client])
    @client.agent_id = current_agent.id

    if current_agent.isgeneralagent == "Retail"
      @client.agency_id = current_agent.agency_id
    else
      @client.generalagency_id = current_agent.generalagency_id
      @client.producingagency_id = $currentproducer
    end

    respond_to do |format|
      if @client.save
        $currentclient = @client.id
        @clientforview = Client.find(@client.id)

        # @client = Client.find(params[:id])
        #see method below: this is called to initialize the policy model and the sub models, also it is used to populate drop downs
        initpolform

        format.js

      else
        format.js
        #format.html { redirect_to(@client)}
        #format.html { render action: "new" }
        #format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end

  end

  def reinstate
    @policypremiumtrans = Policypremiumtransaction.where("policy_id = ? AND (transaction_type = 'Cancel' OR transaction_type = 'Cancel Pending Statement')",params[:id]).last
    @policy = Policy.find(params[:id])
    @policy.effective_date = @policy.effective_date.strftime("%m/%d/%Y")
  end

  def reinstatementtransactions
    @policy = Policy.find(params[:id])
    Policy.new.reinstate(params[:id])
    respond_to do |format|
      format.js
    end

  end

  def existingclient

    if current_agent.isgeneralagent == "Retail"
      @allclients = Client.find_all_by_agency_id(current_agent.agency_id)
    else
      @allclients = Client.find_all_by_generalagency_id(current_agent.generalagency_id)
    end


  end

  def existingprospect


    @allprospects =  Client.where("client_status = 'Prospect' AND agency_id = ?", current_agent.agency_id)



  end

  def createinvoice

  end

  def clientform
    @client = Client.new
  end


  def selectproducingagency
    @producer = Producingagency.find(params[:id])
    $currentproducer = @producer.id
    @policy = Policy.new
    initpolform
  end

  def selectexisting
    @client = Client.find(params[:id])
    $currentclient = @client.id
    initpolform
  end



  def selectprospect
    @prospect = Prospect.find(params[:id])
    @prospect.converttoclient
    @client = Client.find_by_prospect_id(@prospect.id)
    $currentclient = @client.id



    initpolform
  end

  def initpolform
    #this is called to initialize the policy model and the sub models, also it is used to populate drop downs
    @policy = Policy.new
    @policy.policypremiumtransactions.build do |ppt|
      # ppt.invoices.build
      ppt.feetransactions.build
    end

    initpoldropdowns
  end


  def initpoldropdowns
    @agent = Agent.find(current_agent.id)
    if @agent.isgeneralagent == "Retail"
      @pfcs = Pfc.find_all_by_agency_id(current_agent.agency_id)
      @states = Lobcommission.select("state").group(:state, :agency_id).having("agency_id = ?", current_agent.agency_id)
      @carriers = Carrier.where("status = 'Active'").order("carrier_name asc").find_all_by_agency_id(current_agent.agency_id)
      @line = Lineofbusiness.find_all_by_agency_id(current_agent.agency_id)#{"1"=>"Personal","2"=>"Commercial"}
    else
      @pfcs = Pfc.find_all_by_generalagency_id(current_agent.generalagency_id)
      @states = Lobcommission.select("state").group(:state, :generalagency_id).having("generalagency_id = ?", current_agent.generalagency_id)
      @carriers = Carrier.where("status = 'Active'").order("carrier_name asc").find_all_by_generalagency_id(current_agent.generalagency_id)
      if @policy.carrier_id.nil?
        @line = Lineofbusiness.find_all_by_generalagency_id(current_agent.generalagency_id)#{"1"=>"Personal","2"=>"Commercial"}
      else
        @line = []

        lobs = Carrierlob.find_all_by_carrier_id( @policy.carrier_id )
        lobs.each do |clob|
          lobcom = Lobcommission.where('carrierlob_id = ? AND enabled = true', clob)
          billing_type = ""

          lobcom.each do |com|
            if com.billing_type.nil?
              billing_type = "0"
              break
            elsif billing_type.empty?
              billing_type = com.billing_type.to_s
            elsif billing_type != com.billing_type.to_s
              billing_type = "0"
              break
            end
          end

          unless billing_type.empty?
            line = Lineofbusiness.find(clob.lineofbusiness_id)
            line["billing_type"] = billing_type
            @line << line
          end
        end
      end
      @producingagencies = Producingagency.where("status = 'Active'").find_all_by_generalagency_id(current_agent.generalagency_id, :order => "agency_name asc")
    end

    @policyterm = {"term1"=>"6 Month","term2"=>"12 Month", "term3"=>"Other"}
    @coverage= {"1"=>"Homeowners","2"=>"Personal Auto", "3"=>"Umbrella", "4"=>"Boat/Yacht", "5"=>"Commercial Auto"}
    @policytype = {"1"=>"Personal", "2"=>"Corporate"}
    @paymenttype = { "1"=>"Agency Bill - Full, Net", "7"=>"Direct Bill - Installments, Net" }
  end


  def documentupload
    @document = Document.new
    @policyforview = Policy.find(params[:id])
  end

  def createpolicydoc

    @document = Document.new(params[:document])

    @document.policy_id = params[:id]


    if current_agent.isgeneralagent == "Retail"
      @document.agency_id = current_agent.agency_id
    else
      @document.generalagency_id = current_agent.generalagency_id
    end
    @document.agent_id = current_agent.id

    @document.save
    @policy = Policy.find(params[:id])
    respond_to do |format|
      format.js #format .html {render :layout => false}
    end


  end


  def endorse
    @pptendorse = Policypremiumtransaction.new
    @policy = Policy.find(params[:id])
    @lobfees = Lobfee.find_all_by_lineofbusiness_id(@policy.lineofbusiness_id)
    @fees = []
    @lobfees.each do |ld|
      if ld.fee.attach_type == "Always"
        f = Fee.where("id=? AND state =? AND effective_date <= ? AND expiration_date > ?", ld.fee_id, @policy.state, @policy.effective_date,@policy.effective_date)
        if !f.empty?
          @fees<< f
        end
      end
    end
    @pptendorse.feetransactions.build
  end


  def endorsetransactions
    @policy = Policy.find(params[:id])
    @policy.endorse(params[:policypremiumtransaction])

    begin
      if params[:policypremiumtransaction][:endorsetype] != "Return"
        #params[:policypremiumtransaction][:base_premium] = (params[:policypremiumtransaction][:base_premium]).gsub( /[^\d.]/,'').to_f
        #params[:policypremiumtransaction][:total_premium]=  (params[:policypremiumtransaction][:total_premium]).gsub( /[^\d.]/,'').to_f

        if !params[:policypremiumtransaction][:complexfees].nil?
        #  params[:policypremiumtransaction][:complexfees] =  (params[:policypremiumtransaction][:complexfees]).gsub( /[^\d.]/,'').to_f
        else
        #  params[:policypremiumtransaction][:fees] = (params[:policypremiumtransaction][:fees]).gsub( /[^\d.]/,'').to_f
        end
        begin
          params[:policypremiumtransaction][:feetransactions_attributes].each_with_index do |a, index|
            params[:policypremiumtransaction][:feetransactions_attributes][index.to_s][:fee_amount] = (params[:policypremiumtransaction][:feetransactions_attributes][index.to_s][:fee_amount]).gsub( /[^\d.]/,'').to_f
          end
        rescue
        end

        @endorseppt =  Policypremiumtransaction.new(params[:policypremiumtransaction])
        @endorseppt.transaction_type = "Endorse"
      else
        params[:policypremiumtransaction] =  Policypremiumtransaction.new.paramscleancancel(params[:policypremiumtransaction])

        @endorseppt =  Policypremiumtransaction.new(params[:policypremiumtransaction])
        @endorseppt.transaction_type = "Return Premium"
        @endorseppt.cash_received = params[:recmoney]
      end
    end

    # @endorseppt.total_premium = params[:policypremiumtransaction][:total_premium]
    # @endorseppt.policy_id = params[:id]

    #this is here to translate the date format used in the application to the format
    #used in the DB
    # @effdate = Date.strptime(params[:policypremiumtransaction][:transaction_effective_date].to_s, '%m/%d/%Y')
    # @endorseppt.transaction_effective_date = @effdate
    #updating the expiration date of the policy to the cancellation date

    #@endorseppt.save
    #create an invoice for the endorsement, conditions are set for GAs as they bill the endorsement net of commission
    #to producers

    respond_to do |format|
      format.js
    end
  end


  def paycarrier
    @policycash = Cashtransaction.new
    @polid = params[:id]
  end


  def paycarriertransactions
    params[:cashtransaction][:cash_amount] =  (params[:cashtransaction][:cash_amount]).gsub( /[^\d.]/,'').to_f
    @policycash = Cashtransaction.new(params[:cashtransaction])
    @policycash.cash_amount =   params[:cashtransaction][:cash_amount] * 1
    @policy = Policy.find(params[:id])
    @policy.paycarrier(@policycash.cash_amount, @policycash.payment_type, params[:id])
  end


  def applycashtoinvoice
    @cashtransaction = Cashtransaction.new
    @cashtransaction.transaction_effective_date =  Date.today.strftime("%m/%d/%Y")

    @invoice = Invoice.find(params[:id])
  end


  def viewinvoicehistory
    @cashtrans = Cashtransaction.find_all_by_invoice_id(params[:id])
    @invoice = Invoice.find(params[:id])
  end


  def hideinvoicehistory
    @invoice = Invoice.find(params[:id])
  end


  def printinvoice
    @invoice = Invoice.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        datetime = DateTime.now

        pdf = CombinePDF.parse(InvoicePdf.new(@invoice).render)
        pdf << CombinePDF.new("electronicpayment.pdf")
        send_data pdf.to_pdf, filename: "invoice_#{datetime.to_s(:number)}",
        type: "application/pdf",

        disposition: "inline"
      end
    end
  end


  def printcertificate
    @policy = Policy.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        if @policy.lineofbusiness.line_name == "General Liability"
          pdf = AcordPdf.new(@policy)
        else
          pdf = AcordPdf27.new(@policy)
        end


        send_data pdf.render, filename: "certificate_#{@policy.id}",
        type: "application/pdf",
        disposition: "inline"
      end
    end
  end


  def carrierlobs
    @carrierid = params[:carrier_id]
    @lobs = Carrierlob.find_all_by_carrier_id( @carrierid )

    @lines = []
    @lobs.each do |clob|

#      if Lobcommission.where('carrierlob_id = ?', clob).count() > 0
#        @temp = Lineofbusiness.find(clob.lineofbusiness_id)
#        @lines <<  @temp
#      end

      lobcom = Lobcommission.where('carrierlob_id = ? AND enabled = true', clob)
      billing_type = ""

      lobcom.each do |com|
        if com.billing_type.nil?
          billing_type = "0"
          break
        elsif billing_type.empty?
          billing_type = com.billing_type.to_s
        elsif billing_type != com.billing_type.to_s
          billing_type = "0"
          break
        end
      end

      unless billing_type.empty?
        line = Lineofbusiness.find(clob.lineofbusiness_id)
        line["billing_type"] = billing_type
        @lines << line
      end
    end
    render :json =>{:lobs => @lines}
  end


  def feecalcs
    @lob = params[:lob]
    @state = params[:state]
    basepremium = params[:basepremium]
    effectivedate = params[:effective_date]
    @lobdetails = Lobfee.find_all_by_lineofbusiness_id(@lob)

    fees = []
    #feeoutput  = []

    @lobdetails.each do |ld|
      #puts "***** ID"
      #puts ld.fee_id
      f = Fee.where("id=? AND state =? AND effective_date <= ? AND expiration_date > ?", ld.fee_id, @state, Date.strptime(effectivedate, '%m/%d/%Y'),Date.strptime(effectivedate, '%m/%d/%Y'))

      if !f.empty?
        fees<< f
      end
    end

    #add up base premium including revenue fees

    # fees.each do |fee|
    #  if fee[0][:fee_remit_type] == "Revenue"
    #    basepremium = basepremium
    #  end
    #end

    # fees.each do |fee|

    #  feeoutput<<[{:attach_type => fee[0][:attach_type], :cookies => "yes"}]
    #end

    render :json =>{:fees => fees}
  end


  def newquotepolicy
    @policy = Policy.new
    @quote = Quote.find(params[:id])

    @policy.carrier_id = @quote.carrier_id
    @policy.lineofbusiness_id = @quote.lineofbusiness_id
    @policy.state = 'FL'

    if current_agent.isgeneralagent == "GA"
      @policy.namedinsured_id = @quote.submission.namedinsured.id
      @policy.producingagency_id = @quote.submission.producingagency_id

    else
      @client = Client.find(@quote.client_id)
      @policy.client_id = @client.id
    end



    @policy.policypremiumtransactions.build do |ppt|
      ppt.base_premium = @quote.base_premium
      ppt.fees = @quote.total_fees
      ppt.feetransactions.build
    end

    initpoldropdowns
    respond_to do |format|

      format.html # _new.html.erb
      format.json { render json: @policy }
    end
  end




  def newquotepolicyga
    @policy = Policy.new
    @quote = Quote.find(params[:id])

    @policy.carrier_id = @quote.carrier_id
    @policy.lineofbusiness_id = @quote.lineofbusiness_id
    @policy.state = 'FL'
    @policy.description = @quote.quotedescription

    if current_agent.isgeneralagent == "GA"
      @policy.namedinsured_id = @quote.submission.namedinsured.id
      @policy.producingagency_id = @quote.submission.producingagency_id
    else
      @client = Client.find(@quote.client_id)
      @policy.client_id = @client.id
    end

    @policy.build_namedinsured do |named|
      named.named_insured = @quote.submission.namedinsured.named_insured
      named.address_1 = @quote.submission.namedinsured.address_1
      named.address_2 = @quote.submission.namedinsured.address_2
      named.city = @quote.submission.namedinsured.city
      named.state = @quote.submission.namedinsured.state
      named.zip = @quote.submission.namedinsured.zip
    end

    @policy.policypremiumtransactions.build do |ppt|
      ppt.base_premium = @quote.base_premium
      ppt.fees = @quote.total_fees
      ppt.feetransactions.build
    end

    initpoldropdowns
    respond_to do |format|

      format.html # _new.html.erb
      format.json { render json: @policy }
    end
  end


  def agentofrecordchange
    @policy = Policy.find(params[:id])
    @producingagencies = Producingagency.where("status = 'Active'").find_all_by_generalagency_id(current_agent.generalagency_id, :order => "agency_name asc")
  end


  def updateagentofrecord
    @policy = Policy.find(params[:id])
    previousagent = Producingagency.find(@policy.producingagency_id)
    @policy.producingagency_id = params[:policy][:producingagency_id]


    respond_to do |format|
      if @policy.save
        Note.new.createnote(current_agent.id, "Agent of Record Change - Previous Agent: " + previousagent.agency_name.to_s,params[:id],'','','', "AOR")

        format.js
      end
    end
  end


  def nonrenew
    @policy = Policy.find(params[:id])
  end


  def updatenonrenew
    @policy = Policy.find(params[:id])
    @policy.nonrenew
  end


  def pendingcancellation
    @policy = Policy.find(params[:id])
  end


  def updatependingcancellation
    @policy = Policy.find(params[:id])
    @policy.pendingcancellation
  end


  def editcommissionrate
    @policy = Policy.find(params[:id])
  end

  def updatecommissionrate
    @policy = Policy.find(params[:id])
    @policy.updatecommission(params[:producer_comm])
  end


  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  def self.processrenewalsportion policies, days
    report = []
    policies = policies.
       joins( "LEFT JOIN emails e ON e.subject LIKE CONCAT( policies.policy_number, ': less than " + days.to_s + " days before renewal%' ) AND e.created_at > current_date - 100" ).
       where( " e.id IS NULL " ).
       where( " policies.id IN ( SELECT policy_id FROM documents WHERE name LIKE 'Renewal Offer%' ) " ).
       order( "policies.expiration_date desc" )

    #puts policies.to_sql
    #puts policies.count
    policies.each_with_index do | p, i |
      error = ""
      namedinsured = p.namedinsured.named_insured
      email_ar = p.producingagency.main_email.to_s.split ","
      email_ar += p.producingagency.secondary_emails.to_s.split ","
      email_ar += p.producingagency.accounting_email.to_s.split ","
      to_ar = []

      email_ar.each do | addr |
        if !addr.to_s.empty?
          if ( addr =~ VALID_EMAIL_REGEX )
            to_ar.push addr
          else
            error += "Invalid email: #{addr}<br>"
          end
        end
      end

      if to_ar.size == 0
        if error == ""
          error = "Empty email!"
        end
        to = email_ar.join ", "
      else
        error = ""

        to = to_ar.join ", "
        subject = "#{p.policy_number}: less than #{days} days before renewal"
        body = self.getRenewalEmailBody.
              gsub( '<< Current Date >>', Time.now.strftime("%m/%d/%Y") ).
              gsub( '<< Named Insured >>', namedinsured ).
              gsub( '<< Policy Number >>', p.policy_number ).
              gsub( '<< Expiration Date MM/DD/YY >>', p.expiration_date.strftime("%m/%d/%Y") )
        begin
          Processalert.sendrenewalemail( to, subject, body )

          e = Email.new
          e.from = 'quotes@gicunderwriters.com'
          e.to = to
          e.subject = subject
          e.body = body
          e.save
        rescue StandardError => ex
          error = ex.message
        end
      end
      report.push [p.expiration_date, p.id, p.policy_number, namedinsured, to, error, days]
    end
    report
  end


  def self.processpastdueportion invoices, days
    report = []
    invoices = invoices.order( "invoices.due_on desc" )

    #puts invoices.to_sql
    #puts invoices.count
    invoices.each_with_index do | inv, i |
      error = ""
      p = inv.policypremiumtransaction.policy
      namedinsured = p.namedinsured.named_insured
      bal = ActionController::Base.helpers.number_to_currency( inv.outstandingbalance )
      email_ar = []
      unless p.producingagency.nil?
        email_ar = p.producingagency.main_email.to_s.split ","
        email_ar += p.producingagency.secondary_emails.to_s.split ","
        email_ar += p.producingagency.accounting_email.to_s.split ","
      end
      to_ar = []

      email_ar.each do | addr |
        if !addr.to_s.empty?
          if ( addr =~ VALID_EMAIL_REGEX )
            to_ar.push addr
          else
            error += "Invalid email: #{addr}<br>"
          end
        end
      end

      if to_ar.size == 0
        if error == ""
          error = "Empty email!"
        end
        to = email_ar.join ", "
      else
        error = ""
        to = to_ar.join ", "

        subject = "#{p.policy_number}: past due invoice"
        body = self.getPastDueEmailBody.
              gsub( '<< Current Date >>', Time.now.strftime("%m/%d/%Y") ).
              gsub( '<< Named Insured >>', namedinsured ).
              gsub( '<< Policy Number >>', p.policy_number ).
              gsub( '<< Open Balance Due >>', bal )
        begin
          Processalert.sendrenewalemail( to, subject, body )

          e = Email.new
          e.from = 'quotes@gicunderwriters.com'
          e.to = to
          e.subject = subject
          e.body = body
          e.save
        rescue StandardError => ex
          error = ex.message
        end
      end
      report.push [inv.due_on, p.id, p.policy_number, namedinsured, to, error, days, bal]
    end
    report
  end


  def self.getRenewalEmailBody
    body = "
<div><img src=\"https://www.gicunderwriters.com/images/gic_images/gic_underwriters.png\"></div>
<div style=\"text-align:right\"><< Current Date >></div>
<div>&#160;</div>
<div>&#160;</div>
<div>
Re:&#160;&#160;<< Named Insured >></div>
<div>&#160;</div>
<div>
Policy #&#160;&#160;<< Policy Number >></div>
<div>&#160;</div>
<div>&#160;</div>
<div style=\"color:red; text-align:center; font-weight:bold\">
Expiration date:&#160;&#160;<< Expiration Date MM/DD/YY >></div>
<div>&#160;</div>
<div style=\"color:red; text-align:center; font-size:24px;\">
Renewal NOT Received</div>
<div>&#160;</div>
<div>
We are writing to advise that as of today we have not received your renewal bind request for the above-referenced account. We can renew upon receipt of an acceptable request to bind sent to bind@gicunderwriters.com. Your renewal policy will be issued within days.</div>
<div>&#160;</div>
<div>
If there is the possibility of not renewing this policy through us, we ask that you give us a call to discuss coverages, pricing and advantages of keeping the business with GIC Underwriters.  If the policyholder no longer desires coverage or coverage is no longer needed, please let us know and we will close our file.</div>
<div>&#160;</div>
<div>
Please be advised, if coverage expires, previously released renewal terms may no longer apply, and the customer may have a lapse in coverage.</div>
<div>&#160;</div>
<div>
To view a copy of the renewal offer, please visit www.gicunderwriters.com and click on “Manage Your Policies”.</div>
<div>&#160;</div>
<div>
If you feel this is an error, please contact our underwriting department immediately.</div>
<div>&#160;</div>
<div>&#160;</div>
<div>
Thank you for your business!</div>"
  end


  def self.getPastDueEmailBody
    body = "
<div><img src=\"https://www.gicunderwriters.com/images/gic_images/gic_underwriters.png\"></div>
<div style=\"text-align:right\"><< Current Date >></div>
<div>&#160;</div>
<div>&#160;</div>
<div>
Re:&#160;&#160;<< Named Insured >></div>
<div>&#160;</div>
<div>
Policy #&#160;&#160;<< Policy Number >></div>
<div>&#160;</div>
<div>&#160;</div>
<div style=\"color:red; text-align:center; font-weight:bold\">
Balance Due:&#160;&#160;<< Open Balance Due >></div>
<div>&#160;</div>
<div style=\"color:red; text-align:center; font-size:24px;\">
Immediate Payment Required</div>
<div>&#160;</div>
<div>
We are writing to advise that as of today we have not received payment for the above-referenced outstanding balance.</div>
<div>&#160;</div>
<div>
Please be advised, this customer will be set up for Direct Notice of Cancellation for Nonpayment of Premium. Reinstatement is determined on a case-by-case basis and the customer may have a lapse in coverage.</div>
<div>&#160;</div>
<div>
To make a credit card payment, please visit www.gicunderwriters.com and click on “Make a Payment” or email us our Electronic ACH form to payments@gicunderwriters.com</div>
<div>&#160;</div>
<div>
For overnight payments, please send to:</div>
<div style=\"text-align:center; font-weight:bold\">GIC Underwriters, Inc.</div>
<div style=\"text-align:center; font-size:12px; font-weight:bold\">P.O. Box 558810</div>
<div style=\"text-align:center; font-size:12px; font-weight:bold\">Miami, FL 33255-8810</div>
<div>&#160;</div>
<div>
If you feel this is an error, please contact our customer service department immediately.</div>
<div>&#160;</div>
<div>&#160;</div>
<div>
Thank you for your business!</div>"
  end
end
