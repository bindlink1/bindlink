class SubmissionsController < ApplicationController
  before_filter :login_marshall
  layout 'applicationfunctional'
  set_tab :submissionhome, :sidenav, :only => %w(index)
  set_tab :submissionhome, :sidenav, :only => %w(show)
  set_tab :newsubmission, :sidenav, :only => %w(new)
  def new

    @submission = Submission.new
    @producers = Producingagency.where("status = 'Active'").find_all_by_generalagency_id(current_agent.generalagency_id, :order => "agency_name")
    @submission.build_namedinsured
    # @locations = Location.find_all_by_generalagency_id(current_agent.generalagency_id)
    @agents = Agent.where( :is_active => true ).where( "id > 0" ).order( "first_name, last_name" ).find_all_by_generalagency_id(current_agent.generalagency_id)
    @current_agent = current_agent
    # @carriers = Carrier.find_all_by_generalagency_id(current_agent.generalagency_id)
    # @lobcommission = Lobcommission.find_all_by_generalagency_id(current_agent.generalagency_id)
    # @line = Lineofbusiness.find_all_by_generalagency_id(current_agent.generalagency_id)
    respond_to do |format|
      format.js
      format.html # _new.html.erb

    end
  end

  def create
    @submission = Submission.new(params[:submission])

    @submission.generalagency_id = current_agent.generalagency_id

    @submission.namedinsured.generalagency_id = current_agent.generalagency_id
    @submission.namedinsured.producingagency_id = @submission.producingagency_id

    respond_to do |format|
      if @submission.save


        format.html { redirect_to(submission_path(:id => @submission.id)) }


      else

      end
    end

  end

  def show
    @submission = Submission.find(params[:id])
    @namedinsured = Namedinsured.find_all_by_submission_id(params[:id])
    @document = Document.new
    @newnote = @submission.notes.build
    @documentsforview = Document.find_all_by_submission_id(params[:id])
    @quotes = Quote.find_all_by_submission_id(params[:id])
    @notesforview = Note.find_all_by_submission_id(params[:id],:order => "id desc")
  end

  def index
    @submissions = Submission.find_all_by_generalagency_id(current_agent.generalagency.id)
  end

  def view

    @submissionforview = Submission.find(params[:id])
    $currentsubmission = @submissionforview.id
    if agent_signed_in?
      redirect_to ('/welcome') unless Submission.find_all_by_agency_id(current_agent.agency_id).count > 0
      @submissionlist = Submission.find_all_by_agency_id(current_agent.agency_id, :order => "created_at DESC")
      @allconversations = Conversation.find_all_by_submission_id($currentsubmission, :order => "created_at DESC")
    elsif underwriter_signed_in?
      redirect_to ('/welcome') unless Submission.joins("INNER JOIN appointments ON appointments.agency_id = submissions.agency_id").where('appointments.quotingentity_id' =>current_underwriter.quotingentity_id, 'submissions.id' =>params[:id]   ).count > 0
      @submissionlist = Submission.order("created_at DESC").joins("INNER JOIN appointments ON appointments.agency_id = submissions.agency_id").where('appointments.quotingentity_id' =>current_underwriter.quotingentity_id )

      #@allconversations = Conversation.where('conversations.agency_id '=>@submissionforview.agency_id OR 'conversations.quotingentity_id'=>current_underwriter.quotingentity_id , 'conversations.submission_id'=>@submissionforview.id)
      #@allconversations << Conversation.order("created_at DESC").joins("INNER JOIN quotingentities ON quotingentities.id = conversations.quotingentity_id").where('conversations.submission_id'=>$currentsubmission, 'conversations.quotingentity_id' =>current_underwriter.quotingentity_id)
      #@allconversations = Conversation.where('conversations.submission_id = ?',@submissionforview.id)
      @allconversations  = Conversation.find_by_sql(['SELECT * FROM conversations where conversations.submission_id = (?) and (conversations.quotingentity_id IS NULL OR conversations.quotingentity_id = (?)) ORDER BY conversations.created_at DESC',@submissionforview.id, current_underwriter.quotingentity_id ])
    else
      redirect_to "http://127.0.0.1:3000"
    end



  end

  def selectedclient

    @submission = Submission.new
    $clientforsubmission = Client.find(params[:id])

    respond_to do |format|
      format.js
    end

  end
  def postcreated
    @conversationidST = Submissionthread.find($submissionpostthreadid)
    @thisconversation = Conversation.find(@conversationidST.conversation_id)
    @ssd = "Sd"

  end

  def createsubmissiondocument
    @document = Document.new(params[:document])
    @document.submission_id = params[:id]
    @document.agent_id = current_agent.id
    if current_agent.isgeneralagent == "Retail"
      @document.agency_id = current_agent.agency_id
    else
      @document.generalagency_id = current_agent.generalagency_id
    end
    respond_to do |format|
      if @document.save
        @documentsforview = Document.find_all_by_submission_id(params[:id])
        format.js
      end

    end

  end

end
