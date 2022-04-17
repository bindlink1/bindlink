class ProspectsController < ApplicationController
     layout 'applicationfunctional'
    before_filter :login_marshall
    set_tab :prospects
    set_tab :newprospect, :sidenav, :only => %w(new)
      set_tab :prospecthome, :sidenav, :only => %w(view)

    def show
       @agncyprospectsforshow = Prospect.find_all_by_agency_id(current_agent.agency_id)
       @agentprospects = Prospect.find_all_by_agent_id(current_agent.id)
    end

    def new
      @prospect = Prospect.new
      respond_to do |format|
        format.html # _new.html.erb
        format.json { render json: @prospect }
      end
    end

    def create
      @prospect = Prospect.new(params[:prospect])
           @prospect.agent_id = current_agent.id
           @prospect.agency_id = current_agent.agency_id

        respond_to do |format|
          if @prospect.save
          flash[:notice] = "Thanks for adding a new prospect!"
            format.html { redirect_to(@prospect, :notice=> 'prospect was successfully created.') }

            format.json { render json: @prospect, status: :created, location: @prospect }
          else
             format.html { redirect_to(@prospect)}
            format.html { render action: "new" }
            format.json { render json: @prospecterrors, status: :unprocessable_entity }
          end
        end
    end

   def view
     @prospectforview = Prospect.find(params[:id])

   end

  def edit
     @prospect = Prospect.find(params[:id])
     $currentprospect = @prospect.id
  end

    def processedit
    @prospect = Prospect.find($currentprospect)

      respond_to do |format|
        if @prospect.update_attributes(params[:prospect])
          @prospectforview = Prospect.find($currentprospect)
          format.js

        end

      end
    end

  def convert
    @prospect = Prospect.find(params[:id])
    @prospect.converttoclient


  end

end