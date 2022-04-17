class ApplicationsController < ApplicationController
  # GET /applications
  # GET /applications.json
  
 
   
  
  def index
    @applications = Application.all

    respond_to do |format|
      format.html # _new.html.erb
      format.json { render json: @applications }
    end
  end

  # GET /applications/1
  # GET /applications/1.json
  def show
    @application = Application.find(params[:id])

    respond_to do |format|
      format.html # view.html.erbb
      format.json { render json: @application }
    end
  end
  
  # GET /applications/new
  # GET /applications/new.json
  def new
    @application = Application.new

    respond_to do |format|
      format.html # _new.html.erb
      format.json { render json: @application }
    end
  end

  # GET /applications/1/edit
  def edit
    @application = Application.find(params[:id])
  end

  # POST /applications
  # POST /applications.json
  def create
    @application = Application.new(params[:application])
       
 
      respond_to do |format|
      if @application.save
      flash[:notice] = "Thanks for commenting!"
        format.html { redirect_to(@application, :notice=> 'Application was successfully created.') }
        format.js
        #format.json { render json: @application, status: :created, location: @application }
      else
         format.html { redirect_to(@application)}
       # format.html { render action: "new" }
        #format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /applications/1
  # PUT /applications/1.json
  def update
    @application = Application.find(params[:id])

    respond_to do |format|
      if @application.update_attributes(params[:application])
        format.html { redirect_to @application, notice: 'Application was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /applications/1
  # DELETE /applications/1.json
  def destroy
    @application = Application.find(params[:id])
    @application.destroy

    respond_to do |format|
      format.html { redirect_to applications_url }
      format.json { head :ok }
    end
  end
end
