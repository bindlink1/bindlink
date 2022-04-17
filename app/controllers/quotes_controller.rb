class QuotesController < ApplicationController
  layout 'applicationfunctional'
  before_filter :login_marshall

  def new
    if current_agent.isgeneralagent == "GA"
      @submission = Submission.find(params[:submission_id])
      agencyid = current_agent.generalagency_id
      @locations = Location.find_all_by_generalagency_id(agencyid)
      @agents = Agent.where( :is_active => true ).where( "id > 0" ).order( "first_name, last_name" ).find_all_by_generalagency_id(agencyid)
      @carriers = Carrier.find_all_by_generalagency_id(agencyid)
      @lobcommission = Lobcommission.where( "enabled = true and generalagency_id = ?", agencyid )
      @line = Lineofbusiness.find_all_by_generalagency_id(agencyid)
      @quote = @submission.quotes.build
    else
      @client = Client.find(params[:client_id])
      agencyid = current_agent.agency_id
      @locations = Location.find_all_by_agency_id(agencyid)
      @agents = Agent.where( :is_active => true ).where( "id > 0" ).order( "first_name, last_name" ).find_all_by_agency_id(agencyid)
      @carriers = Carrier.find_all_by_agency_id(agencyid)
      @lobcommission = Lobcommission.find_all_by_agency_id(agencyid)
      @line = Lineofbusiness.find_all_by_agency_id(agencyid)
      @quote = @client.quotes.build
    end

    respond_to do |format|
      format.html
    end
  end


  def create
    if current_agent.isgeneralagent == "GA"
      @submission = Submission.find(params[:submission_id])
      @quote = @submission.quotes.create(params[:quote])
      @quote.generalagency_id = current_agent.generalagency_id
    else
      @client = Client.find(params[:client_id])
      @quote = @client.quotes.create(params[:quote])
      @quote.agency_id = current_agent.agency_id
    end

    respond_to do |format|
      if @quote.save
        format.html { redirect_to(quote_path(:id => @quote.id)) }
        format.js
      end
    end
  end

  def show
    @quote = Quote.find(params[:id])
    @document = Document.new
    @newnote = @quote.notes.build
    @documentsforview = Document.find_all_by_quote_id(params[:id])
    @notesforview = Note.find_all_by_quote_id(params[:id],:order => "id desc")
    @tasks = Task.find_all_by_quote_id(params[:id],:order => "id desc")
  end

  def documentupload
    @document = Document.new
  end

  def createquotedocument
    @document = Document.new(params[:document])
    @document.quote_id = params[:id]
    @document.agent_id = current_agent.id

    if current_agent.isgeneralagent == "Retail"
      @document.agency_id = current_agent.agency_id
    else
      @document.generalagency_id = current_agent.generalagency_id
    end


    respond_to do |format|
      if @document.save
        @documentsforview = Document.find_all_by_quote_id(params[:id])
        format.js
      end

    end

  end


  def edit
    @quote = Quote.find(params[:id])

    if current_agent.isgeneralagent == "GA"
      agencyid = current_agent.generalagency_id
      @locations = Location.find_all_by_generalagency_id(agencyid)
      @agents = Agent.where( :is_active => true ).where( "id > 0" ).order( "first_name, last_name" ).find_all_by_generalagency_id(agencyid)
      @carriers = Carrier.find_all_by_generalagency_id(agencyid)
      @lobcommission = Lobcommission.find_all_by_generalagency_id(agencyid)
      @line = Lineofbusiness.find_all_by_generalagency_id(agencyid)
    else
      agencyid = current_agent.agency_id
      @locations = Location.find_all_by_agency_id(agencyid)
      @agents = Agent.where( :is_active => true ).where( "id > 0" ).order( "first_name, last_name" ).find_all_by_agency_id(agencyid)
      @carriers = Carrier.find_all_by_agency_id(agencyid)
      @lobcommission = Lobcommission.find_all_by_agency_id(agencyid)
      @line = Lineofbusiness.find_all_by_agency_id(agencyid)
    end
  end


  def update
    @quote = Quote.find(params[:id])

    respond_to do |format|
      if @quote.update_attributes(params[:quote])

        format.js

      end

    end
  end

  def destroy
    @quote = Quote.find(params[:id])

    if !@quote.submission_id.nil?
      submissionid = @quote.submission_id

    elsif !@quote.client_id.nil?
      clientid = @quote.client_id
    end

    @quote.destroy

    respond_to do |format|

      if !submissionid.nil?
        @quotes = Quote.find_all_by_submission_id(submissionid)
      elsif !clientid.nil?
        @quotes = Quote.find_all_by_client_id(clientid)
      end


      format.js

    end
  end

end
