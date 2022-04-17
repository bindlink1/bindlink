class LocationsController < ApplicationController
  layout 'applicationfunctional'
  before_filter :login_marshall
  set_tab :locationhome, :sidenav, :only => %w(index)

  def index
    @agent = Agent.find(current_agent.id)
    if @agent.isgeneralagent == "Retail"
      @locations = Location.find_all_by_agency_id(current_agent.agency_id)
    else
      @locations  = Location.find_all_by_generalagency_id(current_agent.generalagency_id)
    end
  end

  def new
    @location = Location.new

  end

  def create
    @location = Location.new(params[:location])

    if current_agent.isgeneralagent == "GA"
      @location.generalagency_id = current_agent.generalagency_id
    else

      @location.agency_id = current_agent.agency_id
    end

    respond_to do |format|
      if @location.save
        flash[:notice] = "Thanks for adding a new location!"
        format.html { redirect_to(@location, :notice=> 'location was successfully created.') }

        format.json { render json: @location, status: :created, location: @location }
      else
        format.html { redirect_to(@location)}
        format.html { render action: "new" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @locationforshow = Location.find(params[:id])

  end

  def edit
    @location = Location.find(params[:id])

  end

  def update
    @location = Location.find(params[:id])

    respond_to do |format|
      if @location.update_attributes(params[:location])
        @locationforshow = Location.find(params[:id])
        format.js

      end

    end
  end

  def destroy
    @location = Location.find(params[:id])
    if @location.totalpolcount ==0

      @result = "#{@location.location_nickname} is deleted"
      @direct = "redirect"
      @location.destroy
    else
      @result ="Can't delete, this location has associated clients."
    end


    respond_to do |format|

      format.js

    end


  end

end
