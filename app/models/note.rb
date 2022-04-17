class Note < ActiveRecord::Base
  belongs_to :policy
  belongs_to :client
  belongs_to :prospect
  belongs_to :agent
  belongs_to :agency
  belongs_to :generalagency
  belongs_to :quote
  belongs_to :submission
  has_many :tasks
  attr_accessible :notetext, :agent_id


  def createnote(agent_id, notetext, policy_id, client_id, quote_id, submission_id, note_type )

          @newnote = Note.new
          @newnote.agent_id = agent_id
          @newnote.policy_id = policy_id
          @newnote.client_id = client_id
          @newnote.quote_id = quote_id
          @newnote.submission_id = submission_id
          thisagent = Agent.find(agent_id)

          if thisagent.isgeneralagent == "GA"
              @newnote.generalagency_id = thisagent.generalagency_id
          else
              @newnote.agency_id = thisagent.agency_id
          end
          @newnote.note_type = note_type
          @newnote.notetext = notetext

          @newnote.save


  end


end
