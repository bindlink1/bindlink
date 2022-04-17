class CarrierlobsController < ApplicationController
  layout 'applicationfunctional'
  before_filter :login_marshall

  def new
    @carrierlobs = Carrierlob.new
    @carrierlobs.carrier_id = params[:carrier_id]
    @carrierlobs.lineofbusiness_id = params[:lineofbusiness_id]
    @carrierforview = Carrier.find(params[:carrier_id])

    respond_to do |format|
      if @carrierlobs.save
        @associatedlobs = @carrierforview.associatedlobs

        @alllobs = @carrierforview.nonassociatedlobs(@associatedlobs, current_agent.id)



        format.js

      else
        format.js

      end
    end

  end

  def destroy
    @carrierlobs = Carrierlob.find(params[:id])
    @carrierforview = Carrier.find(@carrierlobs.carrier_id)

    if @carrierlobs.totalpolcount ==0
      @result = "#{@carrierlobs.lineofbusiness.line_name} is removed."
      @direct = "redirect"
      @carrierlobs.destroy
    else
      @result ="Can't remove, this Line has associated policies."
    end

    respond_to do |format|
      @associatedlobs = Carrierlob.find_all_by_carrier_id(@carrierlobs.carrier_id)
      @associatedlobs = @carrierforview.associatedlobs
      @alllobs = @carrierforview.nonassociatedlobs(@associatedlobs, current_agent.id)
      format.js
    end
  end


end
