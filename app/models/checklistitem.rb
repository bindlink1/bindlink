class Checklistitem < ActiveRecord::Base
  belongs_to :checklist

  attr_accessible :task_type, :task_name
end
