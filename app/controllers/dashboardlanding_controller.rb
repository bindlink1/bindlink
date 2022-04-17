class DashboardlandingController < ApplicationController
  layout 'applicationfunctional'
  before_filter :login_marshall
  set_tab :home
  set_tab :home, :sidenav


  def bindlinkWelcome
    if agent_signed_in?
      #start = Time.now
      #puts '-------------------------'
      #puts 'start ' + start.strftime( "%H:%M:%S.%L" )
      @dashboardtype = "Agent"
      #@inboundemails = Inboundemail.where("assigned_flag is null").find_all_by_agency_id(current_agent.agency_id)
      #@submissionlist = Submission.find_all_by_agency_id(current_agent.agency_id, :order => "created_at DESC")
      #@invoicecount = Invoice.where(policies:{generalagency_id: current_agent.generalagency_id}).includes(:policy).count()
      #@accountrec = Accountingtransaction.sum("amount")
      #@taskcount = Task.new.opentaskcount(current_agent.id)

      @tasks = Task.new.tasksearch(current_agent.id, "today")
      @todaycount = Task.new.taskscount(current_agent.id, "today")
      @overduecount = Task.new.taskscount(current_agent.id, "overdue")
      @upcomingcount = Task.new.taskscount(current_agent.id, "future")
      @allcount = Task.new.taskscount(current_agent.id, "all")

      @taskspbi = Task.new.tasksearch( -1, "today")
      @todaycountpbi = Task.new.taskscount( -1, "today")
      @overduecountpbi = Task.new.taskscount( -1, "overdue")
      @upcomingcountpbi = Task.new.taskscount( -1, "future")
      @allcountpbi = Task.new.taskscount( -1, "all")

      @taskspe = Task.new.tasksearch( -2, "today")
      @todaycountpe = Task.new.taskscount( -2, "today")
      @overduecountpe = Task.new.taskscount( -2, "overdue")
      @upcomingcountpe = Task.new.taskscount( -2, "future")
      @allcountpe = Task.new.taskscount( -2, "all")

      @tasksoi = Task.new.tasksearch( -3, "today")
      @todaycountoi = Task.new.taskscount( -3, "today")
      @overduecountoi = Task.new.taskscount( -3, "overdue")
      @upcomingcountoi = Task.new.taskscount( -3, "future")
      @allcountoi = Task.new.taskscount( -3, "all")
      #puts Time.now - start

      if current_agent.isgeneralagent == "Retail"
        @emailcount = Inboundemail.new.emailcount(current_agent.agency_id, current_agent.isgeneralagent)
        @notesforview = Note.find_all_by_agency_id(current_agent.agency_id , :order => "id desc")
        @notespaginate = Kaminari.paginate_array(@notesforview).page(params[:page]).per(10)
      else
        #@emailcount =  Inboundemail.new.emailcount(current_agent.generalagency_id, current_agent.isgeneralagent)
        #@notesforview = Note.find_all_by_agency_id(current_agent.agency_id , :order => "id desc")
        @notesforview = Note.where("agency_id is null").order("id desc").limit(11)
        @notespaginate = Kaminari.paginate_array(@notesforview).page(params[:page]).per(10)
      end
      #puts Time.now - start


      #@cashreport = Cashtransaction.new
      #@policylistingreport = Policypremiumtransaction.new
      #@invoices = Invoice.find_all_by_agency_id(current_agent.agency_id)
      #@odlist = Array.new

      #if current_agent.is_admin?

        @direct_renewal0  = Policy.policyrenewalbyperiodcount(  0, "Direct" )
        @direct_renewal6  = Policy.policyrenewalbyperiodcount(  6, "Direct" )
        @direct_renewal16 = Policy.policyrenewalbyperiodcount( 16, "Direct" )
        @direct_renewal26 = Policy.policyrenewalbyperiodcount( 26, "Direct" )

        @direct_renewal = [
              [ 0,  "0 – 5",   @direct_renewal0,  "direct" ],
              [ 6,  "6 – 15",  @direct_renewal6,  "direct" ],
              [ 16, "16 – 25", @direct_renewal16, "direct" ],
              [ 26, "26+",     @direct_renewal26, "direct" ]]
  
        @agency_renewal0  = Policy.policyrenewalbyperiodcount(  0, "Agency" )
        @agency_renewal6  = Policy.policyrenewalbyperiodcount(  6, "Agency" )
        @agency_renewal16 = Policy.policyrenewalbyperiodcount( 16, "Agency" )
        @agency_renewal26 = Policy.policyrenewalbyperiodcount( 26, "Agency" )

        @agency_renewal = [
              [ 0,  "0 – 5",   @agency_renewal0,  "agency" ],
              [ 6,  "6 – 15",  @agency_renewal6,  "agency" ],
              [ 16, "16 – 25", @agency_renewal16, "agency" ],
              [ 26, "26+",     @agency_renewal26, "agency" ]]

        @aging1  = Invoice.agedinvoicecount( 1 )
        @aging11 = Invoice.agedinvoicecount( 11 )
        @aging16 = Invoice.agedinvoicecount( 16 )
        @aging26 = Invoice.agedinvoicecount( 26 )
      #end
      #puts Time.now - start
      #puts 'end ' + Time.now.strftime( "%H:%M:%S.%L" )
    elsif underwriter_signed_in?
      @dashboardtype = "Underwriter"
      @submissionlist = Submission.order("created_at DESC").joins("INNER JOIN appointments ON appointments.agency_id = submissions.agency_id").where('appointments.quotingentity_id' =>current_underwriter.quotingentity_id)
    elsif admin_signed_in?
      @dashboardtype = "Administrator!"
      @agentsfortable = Agent.where( :is_active => true ).where( "id > 0" ).order( "first_name, last_name" ).find(:all)
      @underwritersfortable = Underwriter.find(:all)
      @quotingentitiesfortable = Quotingentity.find(:all)

    else
      redirect_to "/"
    end
  end


  def policycountchart

    if current_agent.isgeneralagent == "Retail"
      @pptnew = Reportingwarehouse.new.policycountreport(current_agent.agency_id, "Retail")

    else
      @pptnew = Reportingwarehouse.new.policycountreport(current_agent.generalagency_id, "GA")

    end


    render :json =>{:newpols =>  @pptnew}

  end


  def commissionchart

    if current_agent.isgeneralagent == "Retail"
      @comm = Accountingtransaction.new.commissionforchart(current_agent.agency_id, "Retail")

    else
      @comm = Accountingtransaction.new.commissionforchart(current_agent.generalagency_id, "GA")
    end

    render :json =>{:comm =>  @comm}

  end


  def premiumfornonwcmonthly
    @premium = Accountingtransaction.new.premiumforwcmonthly true
    render :json =>{:premium => @premium}
  end


  def premiumforwcmonthly
    @premium = Accountingtransaction.new.premiumforwcmonthly false
    render :json =>{:premium => @premium}
  end


  def activepolcntbycarrier
    if current_agent.isgeneralagent == "Retail"
      @carriercnt = Policy.joins('JOIN carriers ON carriers.id = policies.carrier_id ').where('policies.agency_id = ?', current_agent.agency_id).select('carriers.carrier_name, count(policies.carrier_id) as carrier_count').group('policies.carrier_id,carriers.carrier_name')

    else
      @carriercnt = Policy.joins('JOIN carriers ON carriers.id = policies.carrier_id ').where('policies.generalagency_id = ?', current_agent.generalagency_id).select('carriers.carrier_name, count(policies.carrier_id) as carrier_count').group('policies.carrier_id,carriers.carrier_name')
    end
    render :json =>{:carriercnt => @carriercnt}

  end


end
