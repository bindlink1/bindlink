class ProducingagenciesController < ApplicationController
  layout 'applicationfunctional'
  before_filter :login_marshall, :ga_marshall
  set_tab :producingagencyhome, :sidenav, :only => %w(view)
  set_tab :producingagencyhome, :sidenav, :only => %w(index)
  def new
    @producingagency = Producingagency.new

    respond_to do |format|
      format.html # _new.html.erb
      format.json { render json: @producingagency }
    end
  end

  def create
    @producingagency = Producingagency.new(params[:producingagency])
    @producingagency.status = "Active"
    @producingagency.generalagency_id = current_agent.generalagency_id
    respond_to do |format|
      if @producingagency.save

        format.html { redirect_to(@producingagency, :notice=> 'producingagency was successfully created.') }

        format.json { render json: @producingagency, status: :created, location: @client }
      else
        format.html  { render :action => "new" }
        format.json { render json: @producingagency.errors, status=> :unprocessable_entity }
      end
    end
  end

  def index

    @producingagencies = Producingagency.find_all_by_generalagency_id(current_agent.generalagency_id)
    respond_to do |format|
      format.html
      format.json { render json: ProducingagenciesDatatable.new(view_context, current_agent.generalagency_id) }
    end
  end

  def show
    @document= Document.new
    #TODO create security measure that prevents agent to show producers that are not associated with their  general agency
    @producerforview = Producingagency.find(params[:id])
    @policiesforproducers = Policy.order("effective_date DESC").find_all_by_producingagency_id(params[:id])
    @submissionsforproducers = Submission.where( "producingagency_id = ?", params[:id] ).order( "COALESCE( created_at, '20000101' ) DESC" )
    @documentsforview = Document.find_all_by_producingagency_id(params[:id])
    #TODO place style logic below on whether the producing agency is active or not
    @styleclass = "activestep"
    @notesforview = Note.find_all_by_producingagency_id(params[:id],:order => "id desc")
    @newnote = @producerforview.notes.build
  end


  def edit
    @producer = Producingagency.find(params[:id])
  end

  def update
    @producer = Producingagency.find(params[:id])

    respond_to do |format|
      if @producer.update_attributes(params[:producingagency])
        @producerforview = Producingagency.find(params[:id])
        format.js

      end

    end
  end

  def editgeneral
    @producer = Producingagency.find(params[:id])

  end

  def createproducingagencydoc
    @document = Document.new(params[:document])
    @document.producingagency_id = params[:id]

    if current_agent.isgeneralagent == "Retail"
      @document.agency_id = current_agent.agency_id

    else
      @document.generalagency_id = current_agent.generalagency_id

    end


    @document.agent_id = current_agent.id
    @document.save

    respond_to do |format|
      if @document.save
        @documentsforview = Document.find_all_by_producingagency_id(params[:id])
        format.js
      end

    end
  end

  def booktransfer
    @producingagency = Producingagency.find(params[:id])
     @producingagencies = Producingagency.where("status = 'Active'").order("agency_name ASC")
  end

  def updatebooktransfer
    puts params[:producingagency][:id]
    puts "###########"
    puts params[:id]

    policies = Policy.find_all_by_producingagency_id(params[:id])

    policies.each do |p|

      p.producingagency_id = params[:producingagency][:id]
      p.save
    end


  end

end