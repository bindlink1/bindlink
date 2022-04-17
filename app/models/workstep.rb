class Workstep < ActiveRecord::Base
  belongs_to :workstream
  belongs_to :workitem
end
