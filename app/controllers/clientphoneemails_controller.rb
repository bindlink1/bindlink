class ClientphoneemailsController < ApplicationController
  before_filter :login_marshall

  def new
    @client = Client.find(params[:client_id])
    @cpe = @client.clientphoneemails.build
    respond_to do |format|
      format.js
    end
  end

  def create
    @clientforview = Client.find(params[:client_id])
    @cpe =  @clientforview.clientphoneemails.create(params[:clientphoneemail])
    respond_to do |format|
      if @cpe.save
        @clientcpe = Clientphoneemail.find_all_by_client_id(@clientforview, :order => "id asc")
        format.js
      end
    end
  end

  def destroy
    @cpe = Clientphoneemail.find(params[:id])
    @clientforview = Client.find(@cpe.client_id)
    @cpe.destroy
    respond_to do |format|
      @clientcpe = Clientphoneemail.find_all_by_client_id(@clientforview, :order => "id asc")
      format.js
    end
  end

  def edit
    @cpe = Clientphoneemail.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def update
    @cpe = Clientphoneemail.find(params[:id])
    @clientforview = Client.find(@cpe.client_id)
    respond_to do |format|
      if @cpe.update_attributes(params[:clientphoneemail])
        @clientcpe = Clientphoneemail.find_all_by_client_id(@clientforview, :order => "id asc")
        format.js
      end
    end
  end

end
