class ClientaddressesController < ApplicationController
  before_filter :login_marshall

  def new
    @client = Client.find(params[:client_id])
    @clientaddress = @client.clientaddresses.build
    respond_to do |format|
      format.js
    end
  end

  def create

    @clientforview = Client.find(params[:client_id])
    @clientaddress = @clientforview.clientaddresses.create(params[:clientaddress])
    respond_to do |format|
      if @clientaddress.save
        @clientaddresses = Clientaddress.find_all_by_client_id(@clientforview, :order => "id asc")
        format.js
      end
    end
  end

  def destroy
    @clientaddress = Clientaddress.find(params[:id])

    @clientforview = Client.find(@clientaddress.client_id)
    @clientaddress.destroy
    respond_to do |format|
      @clientaddresses = Clientaddress.find_all_by_client_id(@clientforview, :order => "id asc")
      format.js
    end
  end

  def edit
    @clientaddress = Clientaddress.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def update
    @clientaddress = Clientaddress.find(params[:id])
    @clientforview = Client.find(@clientaddress.client_id)
    respond_to do |format|
      if @clientaddress.update_attributes(params[:clientaddress])
        @clientaddresses = Clientaddress.find_all_by_client_id(@clientforview, :order => "id asc")
        format.js
      end
    end

  end
end
