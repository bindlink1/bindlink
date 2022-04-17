class GeneralagenciesController < ApplicationController
     layout 'applicationfunctional'


  def new
    @generalagency = Generalagency.new

    respond_to do |format|
      format.html # _new.html.erb
      format.json { render json: @generalagency }
    end
  end

  def create
    @generalagency = Generalagency.new(params[:generalagency])


      respond_to do |format|
        if @generalagency.save
        flash[:notice] = "Thanks for adding a new client!"
          format.html { redirect_to(@generalagency, :notice=> 'generalagency was successfully created.') }

          format.json { render json: @generalagency, status: :created, location: @client }
        else
           format.html { redirect_to(@generalagency)}
          format.html { render action: "new" }
          format.json { render json: @generalagency.errors, status: :unprocessable_entity }
        end
      end
  end









end