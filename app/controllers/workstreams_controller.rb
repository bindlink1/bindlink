class WorkstreamsController < ApplicationController
  layout 'applicationfunctional'
  before_filter :login_marshall

  set_tab :workstreamsetup, :sidenav, :only => %w(index)

  def index
    @agent = Agent.find(current_agent.id)
    if @agent.isgeneralagent == "Retail"
      @workstreams = Workstream.find_all_by_agency_id(current_agent.agency_id)
    else
      @workstreams = Workstream.find_all_by_generalagency_id(current_agent.generalagency_id)
    end
  end
end
