class FeesController < ApplicationController
  layout 'applicationfunctional'
  before_filter :login_marshall
  set_tab :feehome, :sidenav, :only => %w(view)

  def initdropdowns
    @remittypes = {"1"=>"Revenue","2"=>"Forward"}
    @feetypes = {"1"=>"Flat","2"=>"Percent"}
    @attachtypes = {"1"=>"New/Renew", "2"=>"Always"}
    @earntypes = {"1" =>"Fully Earned", "2"=>"Pro Rata"}
  end


  def new
    @fee = Fee.new

    initdropdowns
    respond_to do |format|
      format.html # _new.html.erb
      format.json { render json: @fee }
    end
  end


  def create
    @fee = Fee.new(params[:fee])
    @agent = Agent.find(current_agent.id)

    if @agent.isgeneralagent == "Retail"
      @fee.agency_id = current_agent.agency_id
    else
      @fee.generalagency_id = current_agent.generalagency_id
    end

    begin
      effdate = Date.strptime(params[:fee][:effective_date].to_s, '%m/%d/%Y')
      expdate = Date.strptime(params[:fee][:expiration_date].to_s, '%m/%d/%Y')

      @fee.effective_date = effdate
      @fee.expiration_date = expdate
    rescue
      @fee.effective_date = Date.today
      @fee.expiration_date = Date.today
    end

    respond_to do |format|
      if @fee.save
        flash[:notice] = "Thanks for adding a new fee!"
        format.html { redirect_to(fees_path, :notice=> 'fee was successfully created.') }

        format.json { render json: @fee, status: :created, location: @fee }
      else
        format.html { redirect_to(@fee)}
        format.html { render action: "new" }
        format.json { render json: @fee.errors, status: :unprocessable_entity }
      end
    end
  end


  def index
    @agent = Agent.find(current_agent.id)
    if @agent.isgeneralagent == "Retail"
      @fees = Fee.find_all_by_agency_id(current_agent.agency_id)
    else
      @fees = Fee.find_all_by_generalagency_id(current_agent.generalagency_id)
    end
  end


  def edit
    @fee = Fee.find(params[:id])
    begin
      @fee.effective_date = @fee.effective_date.strftime("%m/%d/%Y")
      @fee.expiration_date = @fee.expiration_date.strftime("%m/%d/%Y")
    rescue
    end
    initdropdowns
  end


  def update
    @fee = Fee.find(params[:id])

    begin
      params[:fee][:effective_date] = Date.strptime(params[:fee][:effective_date].to_s, '%m/%d/%Y')
      params[:fee][:expiration_date]= Date.strptime(params[:fee][:expiration_date].to_s, '%m/%d/%Y')
    rescue
    end

    respond_to do |format|
      if @fee.update_attributes(params[:fee])
        @feeforview = Fee.find(params[:id])
        format.js

      end

    end
  end


  def show
    @feeforview = Fee.find(params[:id])
  end
end
