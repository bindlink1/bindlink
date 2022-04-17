class HomeownerpoliciesController < ApplicationController
  before_filter :login_marshall

  def new
     @homepolicy = Homeownerpolicy.new
     @policy = Policy.find(params[:policy_id])
     @consttypes = Hoconsttype.all
     @form = Hoform.all
  end

  def create
    @homepolicy = Homeownerpolicy.new(params[:homeownerpolicy])
    @homepolicy.policy_id = params[:policy_id]
    @homepolicy.save
  end

  def edit
    @homepolicy = Homeownerpolicy.find(params[:id])

  end

  def update

    @homepolicy = Homeownerpolicy.find(params[:id])
    @homepolicy.update_attributes(params[:homeownerpolicy])
    @policyforview = Policy.find(@homepolicy.policy_id)

    respond_to do |format|
      format.js
    end

  end

end
