# handles the aggregation of agency-wide information
# all it needs to know is who the agent is
class Agencymaster
  attr_reader :agent_id

  def initialize(agent_id)
    @agent_id = agent_id
    @agent = Agent.find(@agent_id)
  end




  def statements
    if @agent.isgeneralagent == "Retail"
      @statements = Statement.order("created_at DESC").find_all_by_agency_id(@agent.agency_id)
    else
      @statements = Statement.order("created_at DESC").find_all_by_generalagency_id(@agent.generalagency_id)
    end
  end

  def carriers
    if @agent.isgeneralagent == "Retail"
      @carriers = Carrier.find_all_by_agency_id(@agent.agency_id)
    else
      @carriers = Carrier.find_all_by_generalagency_id(@agent.generalagency_id)
    end
  end


end