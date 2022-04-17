class AcordforminstancesController < ApplicationController
  layout 'applicationnoleftmenu'
  before_filter :login_marshall


  def index
    @acordform = Acordform.find(1)
  end

  def showmenu
    if params[:formmakertype] == 'client'
      @client = Client.find(params[:client_id])
      @acordforminstance = Acordforminstance.new
      @acordforms = Acordform.where('Active = true').all
    end
    respond_to do |format|
      format.js
    end
  end

def new
  @client = Client.find(params[:client_id])

  @acordformbuilder = Acordforminstance.new.prepareacordform(params[:id])
  @acordforminstance = @client.acordforminstances.build


end

def create
 puts "client id"
  puts params[:client_id]
end

def edit

end

def update

end

def delete

end
end
