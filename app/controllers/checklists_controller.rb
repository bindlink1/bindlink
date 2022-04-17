class ChecklistsController < ApplicationController
  layout 'applicationfunctional'
  before_filter :login_marshall

  def index
    if current_agent.isgeneralagent == "GA"
      @checklists = Checklist.find_all_by_generalagency_id(current_agent.generalagency_id)

    else
      @checklists  = Checklist.find_all_by_agency_id(current_agent.agency_id)

    end

  end

  def new
    @checklist = Checklist.new
    @checklist.checklistitems.build

    respond_to do |format|
      format.html # _new.html.erb
      format.json { render json: @carrier }
    end
  end


  def create
    @checklist = Checklist.new(params[:checklist])
    if current_agent.isgeneralagent == "GA"
      @checklist.generalagency_id = current_agent.generalagency_id
    else
      @checklist.agency_id  = current_agent.agency_id
    end
    @checklist.save
    respond_to do |format|
      if @checklist.save
        format.html { redirect_to(checklist_path(@checklist), :notice=> 'carrier was successfully created.') }
      end
    end
  end

  def show
    @checklist = Checklist.find(params[:id])
    @checklistitems = Checklistitem.find_all_by_checklist_id(params[:id])
    if current_agent.isgeneralagent == "GA"
    @lobcommissions = Lobcommission.find_all_by_generalagency_id(current_agent.generalagency_id)
    else
    @lobcommissions = Lobcommission.find_all_by_agency_id(current_agent.agency_id)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @checklist = Checklist.find(params[:id])
    @checklist.update_attributes(params[:checklist])


  end
end
