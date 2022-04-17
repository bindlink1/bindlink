class AppointmentsController < ApplicationController

  def show

    @quotingentitiesformanage = Quotingentity.find(:all)
    @appointment = Appointment.new
    @agency = Agency.find(:all)
    @qelist = Quotingentity.where(appointments:{agency_id: current_agent.agency_id}).includes(:appointments)
    @qelistforexclude = Quotingentity.where(appointments:{agency_id: current_agent.agency_id}).includes(:appointments)



      @notappointcount =  Quotingentity.count(:all, :conditions => ["id NOT IN (?)", @qelistforexclude])

    if @notappointcount > 0
      @notappointedqe = Quotingentity.find(:all, :conditions => ["id NOT IN (?)", @qelistforexclude])

    else
      @notappointedqe = Quotingentity.find(:all)
    end


  end

 def new
   @appointment = Appointment.new
    respond_to do |format|
     format.html # _new.html.erb
      format.json { render json: @appointment }
    end

  end

  def create


    @appointment = Appointment.new(params[:appointment])

    #this is where we are passing information to the new appointment without having to show it on the form
        @appointment.quotingentity_id=$qeforappointment
        @appointment.agency_id= current_agent.agency_id
    respond_to do |format|
        if @appointment.save
        flash[:notice] = "Thanks for adding a new appointment!"
          format.html { redirect_to(@appointment, :notice=> 'appointment was successfully created.') }

          format.json { render json: @appointment, status: :created, location: @appointment }
        else
           format.html { redirect_to(@appointment)}
          format.html { render action: "new" }
          format.json { render json: @appointment.errors, status: :unprocessable_entity }
        end
    end


  end

  def createnew
      @appointment = Appointment.new
      @qetemp = Quotingentity.find(params[:id])
      $qeforappointment = @qetemp.id
      $qeforappointmentname = @qetemp.quotingentity_name

      respond_to do |format|
        format.js
      end


  end
end

