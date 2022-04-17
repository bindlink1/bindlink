class LobcommissionsController < ApplicationController
  layout 'applicationfunctional'
  before_filter :login_marshall

  def new
    @carrierlob = Carrierlob.find(params[:carrierlob_id])
    @lobc = @carrierlob.lobcommissions.build
    @paymenttype = { "1"=>"Agency Bill - Full, Net", "2"=>"Agency Bill - Full, Gross", "3"=>"Agency Bill - Premium Finance, Net", "4"=>"Agency Bill - Premium Finance, Gross", "5"=>"Direct Bill", "6"=>"Direct Bill - Full, Gross", "7"=>"Direct Bill - Installments, Net", "8"=>"Direct Bill - Installments, Gross", "0"=>"Agency and Direct Bill (Both)" }

    respond_to do |format|
      format.js
    end
  end

  def create
    @carrierlob = Carrierlob.find(params[:carrierlob_id])
    @lobc = @carrierlob.lobcommissions.create(params[:lobcommission])

    if current_agent.isgeneralagent == "GA"
      @lobc.generalagency_id = current_agent.generalagency_id
    else

      @lobc.agency_id = current_agent.agency_id
    end

    respond_to do |format|
      if @lobc.save
        @associatedlobs = Carrierlob.find_all_by_carrier_id(@carrierlob.carrier_id)
        format.js
      end
    end
  end

  def edit
    @lobcommission = Lobcommission.find(params[:id])
    @paymenttype = { "1"=>"Agency Bill - Full, Net", "2"=>"Agency Bill - Full, Gross", "3"=>"Agency Bill - Premium Finance, Net", "4"=>"Agency Bill - Premium Finance, Gross", "5"=>"Direct Bill", "6"=>"Direct Bill - Full, Gross", "7"=>"Direct Bill - Installments, Net", "8"=>"Direct Bill - Installments, Gross", "0"=>"Agency and Direct Bill (Both)" }

    respond_to do |format|
      format.js
    end
  end

  def update
    @lobcommission = Lobcommission.find(params[:id])

    respond_to do |format|
      if @lobcommission.update_attributes(params[:lobcommission])
        @associatedlobs = Carrierlob.find_all_by_carrier_id(@lobcommission.carrierlob.carrier_id)
        format.js

      end

    end
  end

  def destroy
    @lobcommission = Lobcommission.find(params[:id])

    if @lobcommission.totalpolcount ==0

      @result = "#{@lobcommission.state} is deleted"
      @direct = "redirect"
      @lobcommission.destroy
    else
      @result ="Can't delete, this State and Line has associated policies."
    end



    respond_to do |format|
      @associatedlobs = Carrierlob.find_all_by_carrier_id(@lobcommission.carrierlob.carrier_id)
      format.js
    end
  end


  def renderscript
    render text: "<script>url = '/carriers/#{@lobcommission.carrierlob.carrier.id}'; if( location.href == url ) location.reload(); else location.href = url;</script>", content_type: 'text/html'
  end


  def disablelob
    @lobcommission = Lobcommission.find(params[:id])
    if @lobcommission.enabled
      @lobcommission.enabled = false
      @lobcommission.save
    end
    renderscript
  end


  def enablelob
    @lobcommission = Lobcommission.find(params[:id])
    if !@lobcommission.enabled
      @lobcommission.enabled = true
      @lobcommission.save
    end
    renderscript
  end
end
