task :completedtaskmigration => :environment do

  @alltasks = Task.all

  @alltasks.each do |task|
    if task.status == "completed"
       Note.new.createnote(task.agent_id, task.task_name,task.policy_id,task.client_id,task.quote_id,task.submission_id, "TaskComplete")
    end
  end



end