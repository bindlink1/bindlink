class Conversation < ActiveRecord::Base
  belongs_to :submission
  belongs_to :quotingentity
  belongs_to :underwriter
  belongs_to :agent
  belongs_to :agency
  has_many :submissionthreads
  has_many :submissionposts, :through => :submissionthreads

  def is_agent
      Agency.count(:all, :conditions => ["id = (?)", self.agency_id])
  end


  def poster_name
        if self.is_agent == 0 then
          [self.underwriter.first_name,self.underwriter.last_name].join(' ')
        else
          [self.agent.first_name, self.agent.last_name].join(' ')
        end
  end

  def company_name
        if self.is_agent == 0 then
          self.underwriter.quotingentity.quotingentity_name
        else
          self.agent.agency.agency_name
        end
  end


end
