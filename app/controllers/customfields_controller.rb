class CustomfieldsController < ApplicationController
  layout 'applicationfunctional'
  before_filter :login_marshall
  set_tab :customfieldhome, :sidenav, :only => %w(index)
  def index
    if current_agent.isgeneralagent == "Retail"
      @customfields = Customfield.find_all_by_agency_id(current_agent.agency_id)
    else
      @customfields = Customfield.find_all_by_generalagency_id(current_agent.generalagency_id)
    end
  end

  def new
    @customfield = Customfield.new
  end

  def create
    @customfield = Customfield.new(params[:customfield])
    if current_agent.isgeneralagent == "Retail"
      @customfield.agency_id = current_agent.agency_id
    else
      @customfield.generalagency_id = current_agent.generalagency_id
    end
    @customfield.save
        if current_agent.isgeneralagent == "Retail"
      @customfields = Customfield.find_all_by_agency_id(current_agent.agency_id)
    else
      @customfields = Customfield.find_all_by_generalagency_id(current_agent.generalagency_id)
    end

  end

  def fieldtype
    customfield_id = params[:customfield_id]
    customfield = Customfield.find(customfield_id)

    render :json =>{:type => customfield.field_type}
  end
end
