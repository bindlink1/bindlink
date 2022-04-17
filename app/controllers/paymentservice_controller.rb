class PaymentserviceController < ApplicationController
  def getpolicyinvoices

    if params[:key]  == "U8twG334wrwb4234fgs"
      @policy = Policy.where(policy_number: params[:policy_id]).order("id DESC").first

      render :template => 'paymentservice/paymentservice.xml.builder', :layout => false

    else
      redirect_to "/"
      logger.warn "UNAUTHORIZED CONNECTION ATTEMPT INVOICES"
    end
  end
end
