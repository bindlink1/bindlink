class ReferralsController < ApplicationController
  before_filter :login_marshall

  def new
    @clientforview = Client.find(params[:client_id])


    @referral = @clientforview.build_referral
    @referral.build_referer


    @referers = Referer.find_all_by_agency_id(current_agent.agency_id)
    @clientsfour = Client.where("id != ? AND referer_id IS NULL", params[:client_id]).order("last_name ASC, corporate_name ASC").find_all_by_agency_id(current_agent.agency_id)

  end


  def create

    @result = Referral.new.createnew(params, current_agent.agency_id)



    @clientforview = Client.find(params[:client_id])

    respond_to do |format|

        format.js

    end

  end

end
