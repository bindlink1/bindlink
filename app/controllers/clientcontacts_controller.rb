class ClientcontactsController < ApplicationController
  before_filter :login_marshall

  def new
    @client = Client.find(params[:client_id])
    @clientcontacts = @client.clientcontacts.build
    respond_to do |format|
      format.js
    end

  end

  def create

    @clientforview = Client.find(params[:client_id])
    @clientcontacts = @clientforview.clientcontacts.create(params[:clientcontact])

    if !params[:clientcontact][:birth_date].blank?
      birthdate = Date.strptime(params[:clientcontact][:birth_date].to_s, '%m/%d/%Y')
      @clientcontacts.birth_date = birthdate
    end
    if !params[:clientcontact][:dlexp].blank?
      dlexp = Date.strptime(params[:clientcontact][:dlexp].to_s, '%m/%d/%Y')
      @clientcontacts.dlexp = dlexp
    end


    respond_to do |format|
      if @clientcontacts.save
        @clientcontacts = Clientcontact.find_all_by_client_id(@clientforview, :order => "id asc")
        format.js
      end
    end
  end

  def destroy
    @clientcontact = Clientcontact.find(params[:id])
    @clientforview = Client.find(@clientcontact.client_id)
    @clientcontact.destroy
    respond_to do |format|
      @clientcontacts = Clientcontact.find_all_by_client_id(@clientforview, :order => "id asc")
      format.js
    end
  end

  def edit
    @clientcontact = Clientcontact.find(params[:id])
    if !@clientcontact.birth_date.blank?
      @clientcontact.birth_date = @clientcontact.birth_date.strftime("%m/%d/%Y")
    end
    if !@clientcontact.dlexp.blank?
      @clientcontact.dlexp = @clientcontact.dlexp.strftime("%m/%d/%Y")
    end

    respond_to do |format|
      format.js
    end
  end

  def update
    @clientcontact = Clientcontact.find(params[:id])
    @clientforview = Client.find(@clientcontact.client_id)

    if !params[:clientcontact][:birth_date].blank?
      params[:clientcontact][:birth_date] = Date.strptime(params[:clientcontact][:birth_date].to_s, '%m/%d/%Y')
    end
    if !params[:clientcontact][:dlexp].blank?
      params[:clientcontact][:dlexp] = Date.strptime(params[:clientcontact][:dlexp].to_s, '%m/%d/%Y')
    end


    respond_to do |format|
      if @clientcontact.update_attributes(params[:clientcontact])
        @clientcontacts  = Clientcontact.find_all_by_client_id(@clientforview, :order => "id asc")

        format.js
      end
    end

  end

end
