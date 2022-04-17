class ClientsController < ApplicationController
  layout 'applicationfunctional'
  set_tab :newclient, :sidenav, :only => %w(new)
  set_tab :clienthome, :sidenav, :only => %w(show)
  set_tab :clienthome, :sidenav, :only => %w(index)
  set_tab :prospecthome, :sidenav, :only => %w(showprospect)

  before_filter :login_marshall
  before_filter :only => ["show", "edit"] do |bf|
    client = Client.find(params[:id])
    if current_agent.isgeneralagent =="GA"
      bf.permission_marshall(client.generalagency_id)
    else
      bf.permission_marshall(client.agency_id)
    end

  end

  def  clientcnt
    if current_agent.isgeneralagent == "Retail"

      #@clientcount = Policy.where('policies.agency_id = ?', current_agent.agency_id).select('client_id, count(client_id) as policy_count').group('client_id')


      @clientcnt = Policy.find_by_sql(["SELECT i.policy_count, count(i.client_id) as client_count FROM (SELECT client_id, count(client_id) as policy_count FROM policies WHERE status = 'Active' AND agency_id = :agency_id GROUP BY client_id) as i WHERE i.policy_count > 0  GROUP BY i.policy_count ORDER BY i.policy_count desc", :agency_id => current_agent.agency_id])



    end
    render :json =>{:clientcnt => @clientcnt}

  end

  def new
    @client = Client.new

    if current_agent.isgeneralagent == "GA"
      @agents = Agent.where( :is_active => true ).where( "id > 0" ).order( "first_name, last_name" ).find_all_by_generalagency_id(current_agent.generalagency_id)
      @locations = Location.find_all_by_generalagency_id(current_agent.generalagency_id)
    else
      @agents = Agent.where( :is_active => true ).where( "id > 0" ).order( "first_name, last_name" ).find_all_by_agency_id(current_agent.agency_id)
      @locations = Location.order("main_location_flag desc").find_all_by_agency_id(current_agent.agency_id)
    end


    respond_to do |format|
      format.js
    end
  end

  def newprospect
    @client = Client.new

    if current_agent.isgeneralagent == "GA"
      @agents = Agent.where( :is_active => true ).where( "id > 0" ).order( "first_name, last_name" ).find_all_by_generalagency_id(current_agent.generalagency_id)
      @locations = Location.find_all_by_generalagency_id(current_agent.generalagency_id)
    else
      @agents = Agent.where( :is_active => true ).where( "id > 0" ).order( "first_name, last_name" ).find_all_by_agency_id(current_agent.agency_id)
      @locations = Location.order("main_location_flag desc").find_all_by_agency_id(current_agent.agency_id)
    end


    respond_to do |format|
      format.js
    end
  end

  def createprospect
    @client = Client.new(params[:client])
    @client.client_status = "Prospect"
    if current_agent.isgeneralagent == "GA"
      @client.generalagency_id = current_agent.generalagency_id
    else

      @client.agency_id = current_agent.agency_id
    end

    respond_to do |format|
      if @client.save
        flash[:notice] = "Thanks for adding a new prospect!"
        format.html { redirect_to(showprospect_path(:id => @client.id), :notice=> 'prospect was successfully created.') }

        format.json { render json: @client, status: :created, location: @client }
      else
        format.html { redirect_to(@client)}
        format.html { render action: "new" }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end



  def create
    @client = Client.new(params[:client])

    if current_agent.isgeneralagent == "GA"
      @client.generalagency_id = current_agent.generalagency_id
    else

      @client.agency_id = current_agent.agency_id
    end

    respond_to do |format|
      if @client.save
        flash[:notice] = "Thanks for adding a new client!"
        format.html { redirect_to(@client, :notice=> 'client was successfully created.') }

        format.json { render json: @client, status: :created, location: @client }
      else
        format.html { redirect_to(@client)}
        format.html { render action: "new" }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end


  end

  def createfrompolicy
    @client = Client.new
    @client = Client.new(params[:client])
    @client.agent_id = current_agent.id
    @client.agency_id = current_agent.agency_id

    respond_to do |format|
      if @client.save
        $currentclient = @client.id
        @clientforview = Client.find(@client)
        @policy = Policy.new
        @policy.invoices.build
        @policyterm = {"term1"=>"6 Month","term2"=>"12 Month"}
        @line = {"1"=>"Personal","2"=>"Commercial"}
        @coverage= {"1"=>"Homeowners","2"=>"Personal Auto", "3"=>"Umbrella", "4"=>"Boat/Yacht", "5"=>"Commercial Auto"}
        @policytype = {"1"=>"Personal", "2"=>"Corporate"}
        @paymenttype = {"1"=>"Agency Bill - Full", "2"=>"Agency Bill - Premium Finance","3"=>"Direct Bill - Full", "4"=>"Direct Bill - Installments" }
        format.js

      else
        format.js
        #format.html { redirect_to(@client)}
        #format.html { render action: "new" }
        #format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end



  end

  def show
    @document= Document.new
    @documentsforview = Document.find_all_by_client_id(params[:id])
    @clientforview = Client.find(params[:id])
    @newnote = @clientforview.notes.build
    @policiesforclients = Policy.where("status='Active'").order("effective_date asc").find_all_by_client_id(params[:id])
    @clientcpe = Clientphoneemail.find_all_by_client_id(params[:id])
    @clientpp = Prospectpolicy.find_all_by_client_id(params[:id])
    @clientaddresses = Clientaddress.find_all_by_client_id(params[:id])
    @clientcontacts = Clientcontact.find_all_by_client_id(params[:id])
    @clientcustomfields = Customfieldvalue.find_all_by_client_id(params[:id])
    @quotes = Quote.find_all_by_client_id(params[:id])
    @notesforview = Note.find_all_by_client_id(params[:id],:order => "id desc")
    @tasks = Task.where("status is null  AND mastertask_id is null").find_all_by_client_id(params[:id],:order => "id desc")
    if !@clientforview.referer_id.nil?
      @referrer = Referer.find_by_client_id(params[:id])
    end
  end



  def showactivepolicies
    @policiesforclients = Policy.where("status='Active'").find_all_by_client_id(params[:id], :order=>"effective_date ASC")
    @clientforview = Client.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def showrenewedpolicies
    @policiesforclients = Policy.where("status='Renewed'").order("effective_date ASC").find_all_by_client_id(params[:id], :order=>"effective_date ASC")
    @clientforview = Client.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def showcancelledpolicies
    @policiesforclients = Policy.where("status='Cancelled'").order("effective_date ASC").find_all_by_client_id(params[:id], :order=>"effective_date ASC")
    @clientforview = Client.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def showexpiredpolicies
    @policiesforclients = Policy.where("status='Expired'").order("effective_date ASC").find_all_by_client_id(params[:id], :order=>"effective_date ASC")
    @clientforview = Client.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def showallpolicies
    @policiesforclients = Policy.order("effective_date ASC").find_all_by_client_id(params[:id], :order=>"effective_date ASC")
    @clientforview = Client.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def showprospect
    @document= Document.new
    @documentsforview = Document.find_all_by_client_id(params[:id])
    @clientforview = Client.find(params[:id])
    @newnote = @clientforview.notes.build
    @policiesforclients = Policy.find_all_by_client_id(params[:id])
    @clientcpe = Clientphoneemail.find_all_by_client_id(params[:id])
    @clientpp = Prospectpolicy.find_all_by_client_id(params[:id])
    @clientaddresses = Clientaddress.find_all_by_client_id(params[:id])
    @clientcontacts = Clientcontact.find_all_by_client_id(params[:id])
    @quotes = Quote.find_all_by_client_id(params[:id])
    @notesforview = Note.find_all_by_client_id(params[:id],:order => "id desc")
    @tasks = Task.find_all_by_client_id(params[:id],:order => "id desc")
  end

  def index


    @recentclients = Client.where("client_status is null AND agency_id = ?", current_agent.agency_id).limit(5).order('created_at desc')


    @currentsidenavitem ="active"
    @currentsidenavicon ="icon-white"

    respond_to do |format|
      format.html
      format.json { render json: ClientsDatatable.new(view_context, current_agent.agency_id) }
    end

  end

  def prospectindex
    if current_agent.isgeneralagent == "Retail"
      @clients = Client.where("client_status = 'Prospect' AND agency_id = ?", current_agent.agency_id)
    else

      @clients = Client.where("client_status = 'Prospect' AND generalagency_id = ?", current_agent.generalagency_id)
    end

    @currentsidenavitem ="active"
    @currentsidenavicon ="icon-white"

  end

  def edit
    @client = Client.find(params[:id])
  end

  def editsalesstage
    @client = Client.find(params[:id])
  end

  def update
    @client = Client.find(params[:id])

    respond_to do |format|
      if @client.update_attributes(params[:client])
        @clientforview = Client.find(params[:id])
        format.js

      end

    end
  end

  def updatesalesstage
    @client = Client.find(params[:id])

    respond_to do |format|
      if @client.update_attributes(params[:client])
        @clientforview = Client.find(params[:id])
        format.js

      end

    end
  end

  def destroy
    @client= Client.find(params[:id])

    if @client.totalpolcount ==0

      @result = "#{@client.client_name} is deleted"
      @direct = "redirect"
      @client.destroy
    else
      @result ="Can't delete, this client has associated policies."
    end


    respond_to do |format|

      format.js

    end
  end

  def documentupload
    @document = Document.new
  end

  def clientcreatedocument
    @document = Document.new(params[:document])
    @document.client_id = params[:id]

    if current_agent.isgeneralagent == "Retail"
      @document.agency_id = current_agent.agency_id

    else
      @document.generalagency_id = current_agent.generalagency_id

    end


    @document.agent_id = current_agent.id
    @document.save

    respond_to do |format|
      if @document.save
        @documentsforview = Document.find_all_by_client_id(params[:id])
        format.js
      end

    end

  end

  def clientname
    @client= Client.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do

        pdf = AcordPdf90fl.new(@client)

        send_data pdf.render, filename: "certificate_#{@client.id}",
                  type: "application/pdf",
                  disposition: "inline"
      end
    end
  end



end



