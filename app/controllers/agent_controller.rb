class AgentController < ApplicationController
  before_filter :login_marshall
  layout 'applicationfunctional'
  def show
    @agent = Agent.find(params[:id])

    respond_to do |format|
      format.html # view.html.erbb
      format.json { render json: @agent }

    end

  end

  def edit
    @agent = Agent.find(params[:id])
  end

  def update
    @agent = Agent.find(params[:id])

    respond_to do |format|
      if @agent.update_attributes(params[:agent])
        @aname = Agency.find(@agent.agency_id)
        @agent.update_attributes(:id=>@agent.id, :agency_name => @aname.agency_name)
        format.html { redirect_to '/welcome', notice: 'Agent was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @agent.errors, status: :unprocessable_entity }
      end
    end
  end


  def login_marshall

    if admin_signed_in?

    else
      redirect_to "http://127.0.0.1:3000"
    end

  end


  def agentpicture
    @document = Document.new
  end


end
