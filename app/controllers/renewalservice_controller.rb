class RenewalserviceController < ApplicationController

  def getrenewaldetails

    if params[:key]  == "U8twG334wrwb4234fgs"
      @policy = Policy.where(policy_number: params[:policy_id]).order("id DESC").first

      render :template => 'renewalservice/renewalservice.xml.builder', :layout => false

    else
      redirect_to "/"
      logger.warn "UNAUTHORIZED RENEWAL ATTEMPT"
    end
  end

end
