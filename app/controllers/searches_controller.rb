class SearchesController < ApplicationController
  layout 'applicationfunctional'
  before_filter :login_marshall

  def new
    @search = Search.new
  end


  def findpolicy
    @search = Search.new.searchforcashentry(params[:searchtext],params[:carrier_id], current_agent.generalagency_id)

    respond_to do |format|
      format.js
    end
  end

  def findpolicyreco
    @search = Search.new.searchforcashentry(params[:searchtext],params[:carrier_id], current_agent.generalagency_id)

    respond_to do |format|
      format.js
    end
  end

  def finduniversal
    if current_agent.isgeneralagent == "GA"
      @universalresults = Search.new.universalsearch(params[:searchtext], current_agent.generalagency_id, "GA", params[:searchtype])
    else
      @universalresults = Search.new.universalsearch(params[:searchtext], current_agent.agency_id, "Retail", params[:searchtype])
    end
    respond_to do |format|
      format.js
    end
  end

  def findtoassociateemail
    @inboundemail = Inboundemail.find(params[:id])
    @searchclient = Search.new.searchbyclient(params[:searchtext], current_agent.agency_id)
    if current_agent.isgeneralagent == "GA"
      @searchpolicy = Search.new.searchbypolicy(params[:searchtext], current_agent.generalagency_id, "GA")
    else
      @searchpolicy = Search.new.searchbypolicy(params[:searchtext], current_agent.agency_id, "Retail")
    end
    respond_to do |format|
      format.js
    end
  end

  def findpolicytransfer

    @search = Search.new.searchforcashentry(params[:q],params[:carrier], current_agent.generalagency_id)
    @search.each do |s|
      puts s.policy_number
      puts "----"
    end
    @cashtransaction = params[:cid]
    respond_to do |format|
      format.js
    end
  end


  def create
    @search = Search.create!(params[:search])
    redirect_to @search
  end


end
