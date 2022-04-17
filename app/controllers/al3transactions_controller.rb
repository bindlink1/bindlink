class Al3transactionsController < ApplicationController
  layout 'applicationfunctional'
  before_filter :login_marshall
  def index
    @altransactions = Al3transaction.where("processed = false").find_all_by_agency_id(current_agent.agency_id)
  end
  def show
    @transaction = Al3transaction.order("").find(params[:id])
  end
  def matchtransaction
    @transaction = Al3transaction.find(params[:id])

    @match = @transaction.al3h2trg.al3h5bpi.findpolicy(@transaction.al3h2trg.al3h5bpi, @transaction.al3h2trg.al3h5bpi.policy_number,@transaction.al3h2trg.al3h5bpi.policy_effective_date)


    respond_to do |format|
      format.js
    end
  end
  def processtransaction
    @transaction = Al3transaction.find(params[:id])
    @transaction.processtransaction


  end

  def processnew

  end

  def destroy
    @al3transaction = Al3transaction.find(params[:id])

    @al3transaction.destroy


  end
end
