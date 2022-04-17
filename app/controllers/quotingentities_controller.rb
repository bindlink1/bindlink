class QuotingentitiesController < ApplicationController
  before_filter :login_marshall


  def new
    @quotingentity = Quotingentity.new
    respond_to do |format|
      format.html # _new.html.erb
      format.json { render json: @quotingentity }
    end
  end


 def create
    @quotingentity = Quotingentity.new(params[:quotingentity])

    respond_to do |format|
        if @quotingentity.save
        flash[:notice] = "Thanks for adding a new Quoting Entity!"
          format.html { redirect_to('/welcome', :notice=> 'Quoting Entity was successfully created.') }

          format.json { render json: @quotingentity, status: :created, location: @quotingentity }
        else
          format.html { redirect_to(@quotingentity)}
          format.html { render action: "new" }
          format.json { render json: @quotingentity.errors, status: :unprocessable_entity }
        end
    end

  end





end
