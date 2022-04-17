class PolicypremiumtransactionsController < ApplicationController
  before_filter :login_marshall
  layout 'applicationfunctional'
  def newadjustment
    @ppt = Policypremiumtransaction.find(params[:id])
    policy = Policy.find(@ppt.policy_id)
    @carrierlob = Carrierlob.where("carrier_id =? AND lineofbusiness_id =?", policy.carrier_id,policy.lineofbusiness_id )

    if @ppt.adjusted == 'Yes'
      @ppt.base_premium = @ppt.adjustmentbasep
    end

    transfees = []
    feetrans = Feetransaction.where('policypremiumtransaction_id =?', @ppt.id).select('fee_id')

    feetrans.each do |ft|
      transfees << ft.fee_id
    end

    @fees =   Lobfee.where('fee_id IN (?) AND lineofbusiness_id=?', transfees, policy.lineofbusiness_id)


    @ppt.feetransactions.build
  end

  def processadjustment
    params[:policypremiumtransaction] =  Policypremiumtransaction.new.paramsclean(params[:policypremiumtransaction], false)

    Policypremiumtransaction.new.adjusttransaction(params[:policypremiumtransaction], params[:id])
    adjusted = Policypremiumtransaction.find(params[:id])

    @policy = Policy.find(adjusted.policy_id)

    respond_to do |format|
      @pptforview = Policypremiumtransaction.find_all_by_policy_id(adjusted.policy_id)
      format.js
    end
  end

  def reconcilesingleppt
    ppt = Policypremiumtransaction.find(params[:id])

    ppt.reconcile(ppt.id, 'single')

    @policy = ppt.policy

  end

  def recordentry

  end


end