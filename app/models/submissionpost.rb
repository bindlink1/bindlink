class Submissionpost < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :submissionthread
  belongs_to :quotingentity
  belongs_to :underwriter
  belongs_to :agent
  belongs_to :agency

  def is_agent
      Agency.count(:all, :conditions => ["id = (?)", self.agent_id])

  end

  def is_und
     Underwriter.count(:all, :conditions => ["id = (?)", self.underwriter_id])
  end




  def poster_name
        if self.is_agent == 0 then
          if self.is_und == 0 then

          else
              u = Underwriter.find(self.underwriter_id)

              u.first_name

              [u.first_name, u.last_name].join(' ')
          end

        else
          a = Agent.find(self.agent_id)
          a.first_name
          [a.first_name, a.last_name].join(' ')
        end
  end


end
