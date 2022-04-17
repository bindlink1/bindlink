class LobfeesController < ApplicationController
  layout 'applicationfunctional'
  before_filter :login_marshall


  def new
    @lobfees = Lobfee.new
    @lobfees.lineofbusiness_id = params[:lineofbusiness_id]
    @lobfees.fee_id = params[:fee_id]
    @lobforview = Lineofbusiness.find(params[:lineofbusiness_id])

    respond_to do |format|
      if @lobfees.save
        @associatedfees = @lobforview.associatedfees

        @allfees = @lobforview.nonassociatedfees(@associatedfees, current_agent.id)

        format.js

      else
        format.js

      end
    end

  end

  def destroy
    @lobfee = Lobfee.find(params[:id])
    @lobforview = Lineofbusiness.find(@lobfee.lineofbusiness_id)

    @lobfee.destroy

    respond_to do |format|
      @associatedfees = @lobforview.associatedfees

      @allfees = @lobforview.nonassociatedfees(@associatedfees, current_agent.id)
      format.js
    end
  end


end
