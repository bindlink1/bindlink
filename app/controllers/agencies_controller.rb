class AgenciesController < ApplicationController

  def new
    @agency = Agency.new

    respond_to do |format|
      format.html # _new.html.erb
      format.json { render json: @agency }
    end
  end
  def create
    @agency = Agency.new(params[:agency])
       
 
      respond_to do |format|
        if @agency.save
        flash[:notice] = "Thanks for adding a new Agency!"
          format.html { redirect_to(@agency, :notice=> 'Agency was successfully created.') }
  
          format.json { render json: @agency, status: :created, location: @agency }
        else
           format.html { redirect_to(@agency)}
          format.html { render action: "new" }
          format.json { render json: @agency.errors, status: :unprocessable_entity }
        end
      end
  end
  
  def find_all_agencies
    @agencies = Agency.all

    end
end

  
  
  

