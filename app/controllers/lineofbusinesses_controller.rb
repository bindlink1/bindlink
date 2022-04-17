class LineofbusinessesController < ApplicationController
  layout 'applicationfunctional'
  before_filter :login_marshall
  set_tab :lobhome, :sidenav, :only => %w(view)
  def new
    @lob = Lineofbusiness.new
    respond_to do |format|
      format.html # _new.html.erb
      format.json { render json: @lob }
    end
  end

  def create
    @lob = Lineofbusiness.new(params[:lineofbusiness])
    @agent = Agent.find(current_agent.id)

    if @agent.isgeneralagent == "Retail"
      @lob.agency_id = current_agent.agency_id
    else
      @lob.generalagency_id = current_agent.generalagency_id
    end


    respond_to do |format|
      if @lob.save
        flash[:notice] = "Thanks for adding a new lob!"
        format.html { redirect_to(@lob, :notice=> 'lob was successfully created.') }

        format.json { render json: @lob, status: :created, location: @lob }
      else
        format.html { redirect_to(@lob)}
        format.html { render action: "new" }
        format.json { render json: @lob.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    @agent = Agent.find(current_agent.id)
    if @agent.isgeneralagent == "Retail"
      @lobs = Lineofbusiness.find_all_by_agency_id(current_agent.agency_id)
    else
      @lobs = Lineofbusiness.find_all_by_generalagency_id(current_agent.generalagency_id)
    end

  end


  def show
    @lobforview = Lineofbusiness.find(params[:id])
    @associatedfees = @lobforview.associatedfees
    @allfees = @lobforview.nonassociatedfees(@associatedfees, current_agent.id)
    @lobfee = Lobfee.new
  end

  def edit
   @lob = Lineofbusiness.find(params[:id])

  end

  def update
    @lob = Lineofbusiness.find(params[:id])
    respond_to do |format|
      if @lob.update_attributes(params[:lineofbusiness])
        @lobforview = Lineofbusiness.find(params[:id])
        format.js

      end

    end
  end

end