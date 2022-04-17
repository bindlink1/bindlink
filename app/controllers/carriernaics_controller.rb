class CarriernaicsController < ApplicationController
  before_filter :login_marshall

  def new
    @carrier = Carrier.find(params[:carrier_id])
    @naicnumber = @carrier.carriernaics.build
    respond_to do |format|
      format.js
    end
  end

  def create

    @carrierforview = Carrier.find(params[:carrier_id])
    params[:carriernaic][:agency_id] = current_agent.agency_id
    @carrierforview.carriernaics.create(params[:carriernaic])
    respond_to do |format|
      format.js

    end
  end

  def destroy


    @carriernaic = Carriernaic.find(params[:id])
    @carriernaic.destroy
    respond_to do |format|
      if @carriernaic.update_attributes(params[:carriernaic])
        @carrierforview = Carrier.find(@carriernaic.carrier_id)
        format.js
      end
    end

  end

  def edit
    @carriernaic = Carriernaic.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def update

    @carriernaic = Carriernaic.find(params[:id])
    respond_to do |format|
      if @carriernaic.update_attributes(params[:carriernaic])
        @carrierforview = Carrier.find(@carriernaic.carrier_id)
        format.js
      end
    end

  end
end
