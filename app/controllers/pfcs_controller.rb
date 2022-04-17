class PfcsController  < ApplicationController
  layout 'applicationfunctional'
  before_filter :login_marshall
  set_tab :pfcs
  set_tab :pfchome, :sidenav, :only => %w(view)

  def new
    @pfc = Pfc.new
    respond_to do |format|
      format.html # _new.html.erb
      format.json { render json: @pfc }
    end
  end

  def create
    @pfc = Pfc.new(params[:pfc])
    @agent = Agent.find(current_agent.id)

    if @agent.isgeneralagent == "Retail"
      @pfc.agency_id = current_agent.agency_id
    else
      @pfc.generalagency_id = current_agent.generalagency_id
    end


    respond_to do |format|
      if @pfc.save
        flash[:notice] = "Thanks for adding a new pfc!"
        format.html { redirect_to(pfcs_path, :notice=> 'pfc was successfully created.') }

        format.json { render json: @pfc, status: :created, location: @pfc }
      else
        format.html { redirect_to(@pfc)}
        format.html { render action: "new" }
        format.json { render json: @pfc.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    @agent = Agent.find(current_agent.id)
    if @agent.isgeneralagent == "Retail"
      @pfcs = Pfc.find_all_by_agency_id(current_agent.agency_id)
    else
      @pfcs = Pfc.find_all_by_generalagency_id(current_agent.generalagency_id)
    end

  end

  def show

    @pfcforview = Pfc.find(params[:id])

  end

  def edit
    @pfc = Pfc.find(params[:id])
  end

  def update
    @pfc = Pfc.find(params[:id])

    respond_to do |format|
      if @pfc.update_attributes(params[:pfc])
        @pfcforview = Pfc.find(params[:id])
        format.js

      end

    end
  end











end