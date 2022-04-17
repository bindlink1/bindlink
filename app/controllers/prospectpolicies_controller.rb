class ProspectpoliciesController < ApplicationController
  before_filter :login_marshall


  def new
    @client = Client.find(params[:client_id])
    @pp = @client.prospectpolicies.build
    respond_to do |format|
      format.js
    end
  end

  def create
    @client = Client.find(params[:client_id])
    @clientforview = Client.find(params[:client_id])
    begin
      expdate = Date.strptime(params[:prospectpolicy][:expiration_date].to_s, '%m/%d/%Y')
      @pp.expiration_date = expdate
    rescue

    end
    @pp = @client.prospectpolicies.create(params[:prospectpolicy])

    respond_to do |format|
      if @pp.save
        @clientpp = Prospectpolicy.find_all_by_client_id(@client, :order => "id asc")
        format.js
      end
    end
  end

  def destroy
    @pp = Prospectpolicy.find(params[:id])
    @clientforview = Client.find(@pp.client_id)
    @pp.destroy
    respond_to do |format|
      @clientpp = Prospectpolicy.find_all_by_client_id(@clientforview, :order => "id asc")
      format.js
    end
  end

  def edit
    @pp = Prospectpolicy.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def update
    @pp = Prospectpolicy.find(params[:id])
    params[:prospectpolicy][:expiration_date] = Date.strptime(params[:prospectpolicy][:expiration_date].to_s, '%m/%d/%Y')

    @clientforview = Client.find(@pp.client_id)
    respond_to do |format|
      if @pp.update_attributes(params[:prospectpolicy])
        @clientpp = Prospectpolicy.find_all_by_client_id(@clientforview, :order => "id asc")
        format.js
      end
    end
  end
end
