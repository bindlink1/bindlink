class Task < ActiveRecord::Base
  belongs_to :policy
  belongs_to :agent
  belongs_to :agency
  belongs_to :generalagency
  belongs_to :client
  belongs_to :quote
  belongs_to :note
  has_many :subordinates, :class_name => "Task", :foreign_key => "mastertask_id"
  belongs_to :mastertask, :class_name => "Task", :foreign_key => "mastertask_id"

  attr_accessible :task_name, :task_type, :agent_id, :reminder_date


  def opentaskcount(agentid)
      @count = Task.where("agent_id=? AND mastertask_id IS NULL AND status IS NULL", agentid).count()

  end

    def overduetaskcount(agentid)
      @count =Task.where("status is null AND reminder_date  < ? ", (Date.today) ).find_all_by_agent_id(agentid).count()

  end


  def tasksearch(agentid, type)

    if type == "today"
      tasks = Task.where("status is null AND mastertask_id is null AND reminder_date = ?", (Date.today )).find_all_by_agent_id(agentid)

    elsif type =="future"
      tasks = Task.where("status is null AND mastertask_id is null AND (reminder_date  > ? OR reminder_date is null)", (Date.today )).order("reminder_date ASC").find_all_by_agent_id(agentid)

    elsif type == "overdue"
      tasks= Task.where("status is null AND mastertask_id is null AND reminder_date  < ? ", (Date.today) ).find_all_by_agent_id(agentid,:order => "reminder_date ASC")

    elsif type == "all"
      tasks= Task.where("status is null AND mastertask_id is null " ).find_all_by_agent_id(agentid,:order => "reminder_date ASC")

    end

   return tasks

  end

    def taskscount(agentid, type)

    if type == "today"
      tasks = Task.where("status is null AND mastertask_id is null AND reminder_date = ?", (Date.today )).find_all_by_agent_id(agentid).count()

    elsif type =="future"
      tasks = Task.where("status is null AND mastertask_id is null AND (reminder_date  > ? OR reminder_date is null)", (Date.today )).order("reminder_date ASC").find_all_by_agent_id(agentid).count()

    elsif type == "overdue"
      tasks= Task.where("status is null AND mastertask_id is null AND reminder_date  < ? ", (Date.today) ).find_all_by_agent_id(agentid,:order => "reminder_date ASC").count()

    elsif type == "all"
      tasks= Task.where("status is null AND mastertask_id is null " ).find_all_by_agent_id(agentid,:order => "reminder_date ASC").count()

    end

   return tasks

  end

end
