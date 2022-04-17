class CarriersController  < ApplicationController
  layout 'applicationfunctional'
  before_filter :login_marshall
  set_tab :carriers
  set_tab :carrierhome, :sidenav, :only => %w(view)


  def new
    @carrier = Carrier.new
    respond_to do |format|
      format.html # _new.html.erb
      format.json { render json: @carrier }
    end
  end

  def create
    @carrier = Carrier.new(params[:carrier])
    @agent = Agent.find(current_agent.id)

    if @agent.isgeneralagent == "Retail"
      @carrier.agency_id = current_agent.agency_id
    else
      @carrier.generalagency_id = current_agent.generalagency_id
    end


    respond_to do |format|
      if @carrier.save
        flash[:notice] = "Thanks for adding a new carrier!"
        format.html { redirect_to(carriers_path, :notice=> 'carrier was successfully created.') }

      else
        format.html { redirect_to(@carrier)}
        format.html { render action: "new" }

      end
    end
  end

  def index
    @agent = Agent.find(current_agent.id)
    if @agent.isgeneralagent == "Retail"
      @carriers = Carrier.order("carrier_name ASC").find_all_by_agency_id(current_agent.agency_id)
    else
      @carriers = Carrier.order("carrier_name ASC").find_all_by_generalagency_id(current_agent.generalagency_id)
    end

  end

  def show

    @carrierforview = Carrier.find(params[:id])

    @associatedlobs = @carrierforview.associatedlobs

    @alllobs = @carrierforview.nonassociatedlobs(@associatedlobs, current_agent.id)

  end


  def edit
    @carrier = Carrier.find(params[:id])
  end


  def update
    @carrier = Carrier.find(params[:id])

    respond_to do |format|
      if @carrier.update_attributes(params[:carrier])
        @carrierforview = Carrier.find(@carrier)
        format.js

      end

    end
  end

end
