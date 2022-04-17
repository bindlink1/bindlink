class JournalentriesController < ApplicationController
  layout 'applicationfunctional'
  before_filter :login_marshall

  def new
      @policy = Policy.find(params[:policy_id])
      @je = Journalentry.new
      @accounts = Accountingaccount.all

  end

  def create
    @je = Journalentry.new(params[:journalentry])
    @je.save

    @je.process

  end
end
