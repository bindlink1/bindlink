class TasksController < ApplicationController
  layout 'applicationfunctional'
  before_filter :login_marshall


  def showcompletedtasks
    if params[:type] == "Client"
      @tasks = Task.where("status = 'completed'  AND mastertask_id is null").find_all_by_client_id(params[:id],:order => "id desc")
    elsif params[:type] == "Policy"
      @tasks = Task.where("status = 'completed'  AND mastertask_id is null").find_all_by_policy_id(params[:id],:order => "id desc")
    end

    respond_to do |format|
      format.js
    end
  end


  def showoutstandingtasks
    if params[:type] == "Client"
      @tasks = Task.where("status is null  AND mastertask_id is null").find_all_by_client_id(params[:id],:order => "id desc")
    elsif params[:type] == "Policy"
      @tasks = Task.where("status is null  AND mastertask_id is null").find_all_by_policy_id(params[:id],:order => "id desc")
    end

    respond_to do |format|
      format.js
    end
  end


  def new
    if !params[:policy_id].nil?
      @policy = Policy.find(params[:policy_id])
      @task = @policy.tasks.build
    elsif !params[:client_id].nil?
      @client = Client.find(params[:client_id])
      @task = @client.tasks.build
    elsif !params[:quote_id].nil?
      @quote = Quote.find(params[:quote_id])
      @task = @quote.tasks.build
    end

    @task.agent_id = current_agent.id
    if current_agent.isgeneralagent == "GA"
      @agents = Agent.where( :is_active => true ).order( "concat( first_name, last_name )" ).find_all_by_generalagency_id(current_agent.generalagency_id)
    else
      @agents = Agent.where( :is_active => true ).order( "concat( first_name, last_name )" ).find_all_by_agency_id(current_agent.agency_id)
    end

    respond_to do |format|
      format.js
    end
  end


  def newtaskreply
    @task = Task.new
    @task.mastertask_id = params[:id]
    @task.agent_id = current_agent.id
    if current_agent.isgeneralagent == "GA"
      @agents = Agent.where( :is_active => true ).order( "concat( first_name, last_name )" ).find_all_by_generalagency_id(current_agent.generalagency_id)
    else
      @agents = Agent.where( :is_active => true ).order( "concat( first_name, last_name )" ).find_all_by_agency_id(current_agent.agency_id)
    end

    respond_to do |format|
      format.js
    end
  end


  def create
    if  !params[:policy_id].nil?
      @policy = Policy.find(params[:policy_id])
      @task = @policy.tasks.create(params[:task])
    elsif !params[:client_id].nil?
      @client = Client.find(params[:client_id])
      @task = @client.tasks.create(params[:task])
    elsif !params[:quote_id].nil?
      @quote = Quote.find(params[:quote_id])
      @task = @quote.tasks.create(params[:task])
      if current_agent.isgeneralagent == "GA"
        @task.submission_id = @quote.submission.id
      else
        @task.client_id = @quote.client.id
      end
    end

    begin
      remdte = Date.strptime(params[:task][:reminder_date].to_s, '%m/%d/%Y')
      @task.reminder_date = remdte
    rescue
    end

    if current_agent.isgeneralagent == "GA"
      @task.generalagency_id = current_agent.generalagency_id
    else
      @task.agency_id = current_agent.agency_id
    end

    respond_to do |format|
      if @task.save
        if  !params[:policy_id].nil?
          @tasks = Task.find_all_by_policy_id(params[:policy_id])
        elsif !params[:client_id].nil?
          @tasks = Task.find_all_by_client_id(params[:client_id])
        elsif !params[:quote_id].nil?
          @tasks = Task.find_all_by_quote_id(params[:quote_id])
        end
        format.js
      end
    end
  end

  def createreply
    @task = Task.new(params[:task])
    @task.mastertask_id = params[:id]
    begin
      remdte = Date.strptime(params[:task][:reminder_date].to_s, '%m/%d/%Y')
      @task.reminder_date = remdte
    rescue
    end

    if current_agent.isgeneralagent == "GA"
      @task.generalagency_id = current_agent.generalagency_id
    else
      @task.agency_id = current_agent.agency_id
    end

    respond_to do |format|
      if @task.save

        format.js
      end
    end
  end


  def completetask

    @task = Task.find(params[:id])

    if @task.status == 'completed'
      @task.status = nil
    else
      @task.status =  'completed'
    end

    if @task.save
      Note.new.createnote(current_agent.id, @task.task_name,@task.policy_id,@task.client_id,@task.quote_id,@task.submission_id, "TaskComplete")
    end


    @todaycount = Task.new.taskscount(@task.agent.id, "today")
    @overduecount = Task.new.taskscount(@task.agent.id, "overdue")
    @upcomingcount = Task.new.taskscount(@task.agent.id, "future")
    @allcount = Task.new.taskscount(@task.agent.id, "all")

  end


  def edit
    @task = Task.find(params[:id])

    begin
      @task.reminder_date = @task.reminder_date.strftime("%m/%d/%Y")
    rescue
    end

    if current_agent.isgeneralagent == "GA"
      @agents = Agent.where( :is_active => true ).order( "concat( first_name, last_name )" ).find_all_by_generalagency_id(current_agent.generalagency_id)
    else
      @agents = Agent.where( :is_active => true ).order( "concat( first_name, last_name )" ).find_all_by_agency_id(current_agent.agency_id)
    end
  end


  def update

    @task = Task.find(params[:id])
    begin
      params[:task][:reminder_date] = Date.strptime(params[:task][:reminder_date].to_s, '%m/%d/%Y')

    rescue
    end
    respond_to do |format|
      if @task.update_attributes(params[:task])
        @todaycount = Task.new.taskscount(params[:task][:agent_id], "today")
        @overduecount = Task.new.taskscount(params[:task][:agent_id], "overdue")
        @upcomingcount = Task.new.taskscount(params[:task][:agent_id], "future")
        @allcount = Task.new.taskscount(params[:task][:agent_id], "all")
        format.js
      end
    end

  end

  def destroy
    @task = Task.find(params[:id])
    agentid = @task.agent.id
    @task.destroy
    respond_to do |format|
      @todaycount = Task.new.taskscount(agentid, "today")
      @overduecount = Task.new.taskscount(agentid, "overdue")
      @upcomingcount = Task.new.taskscount(agentid, "future")
      @allcount = Task.new.taskscount(agentid, "all")
      @taskid = params[:id]
      format.js
    end

  end

  def taskview
    type = params[:type]
    agent = params[:agent]
    @tasks = Task.new.tasksearch( agent, type )
    case agent
    when "-1"
      @suffix = "pbi"
    when "-2"
      @suffix = "pe"
    when "-3"
      @suffix = "oi"
    else
      @suffix = ""
    end
    respond_to do |format|
      format.js
    end
  end

  def show
    @task = Task.find(params[:id])
    respond_to do |format|
      format.js
    end

  end

end
