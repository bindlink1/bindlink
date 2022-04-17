class ReferersController < ApplicationController
  layout 'applicationfunctional'
  before_filter :login_marshall
  set_tab :referrershome, :sidenav, :only => %w(index)

  def create
    @referer = Referer.new(params[:referer])
    @cpe = @client.clientphoneemails.create(params[:clientphoneemail])
    respond_to do |format|
      if @cpe.save
        @clientcpe = Clientphoneemail.find_all_by_client_id(@client, :order => "id asc")
        format.js
      end
    end
  end

  def index
    @referers = Referer.find_all_by_agency_id(current_agent.agency_id)


  end

  def show

    @referrer = Referer.find(params[:id])

  end

end
