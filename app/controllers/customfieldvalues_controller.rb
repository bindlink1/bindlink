class CustomfieldvaluesController < ApplicationController
  layout 'applicationfunctional'
  before_filter :login_marshall


  def new

    @client = Client.find(params[:client_id])
    @cfv = @client.customfieldvalues.build
    if current_agent.isgeneralagent == "Retail"
      @customfields = Customfield.find_all_by_agency_id(current_agent.agency_id)
    else
      @customfields = Customfield.find_all_by_generalagency_id(current_agent.generalagency_id)
    end
    respond_to do |format|
      format.js
    end
  end

  def create

    @client = Client.find(params[:client_id])
    @cfv = @client.customfieldvalues.create(params[:customfieldvalue])

    if !params[:customfieldvalue][:value_date].blank?
      valdate = Date.strptime(params[:customfieldvalue][:value_date].to_s, '%m/%d/%Y')
      @cfv.value_date = valdate
    end

    respond_to do |format|
      if @cfv.save
        @clientcustomfields = Customfieldvalue.find_all_by_client_id(@client, :order => "id asc")
        format.js
      end
    end

  end

  def show
    @cfv = Customfieldvalue.find(params[:id])

  end

  def edit
    @cfv = Customfieldvalue.find(params[:id])

    if !@cfv.value_date.nil?
      @cfv.value_date =  @cfv.value_date.strftime("%m/%d/%Y")
    end

    if current_agent.isgeneralagent == "Retail"
      @customfields = Customfield.find_all_by_agency_id(current_agent.agency_id)
    else
      @customfields = Customfield.find_all_by_generalagency_id(current_agent.generalagency_id)
    end
  end

  def update
    @cfv = Customfieldvalue.find(params[:id])

    if !params[:customfieldvalue][:value_date].blank?
      params[:customfieldvalue][:value_date] = Date.strptime(params[:customfieldvalue][:value_date].to_s, '%m/%d/%Y')

    end


    @cfv.update_attributes(params[:customfieldvalue])

  end

  def destroy
    @cfv = Customfieldvalue.find(params[:id])
    @clientforview = Client.find(@cfv.client_id)
    @cfv.destroy
    respond_to do |format|
      @clientcustomfields = Customfieldvalue.find_all_by_client_id(@clientforview, :order => "id asc")
      format.js
    end
  end
end




