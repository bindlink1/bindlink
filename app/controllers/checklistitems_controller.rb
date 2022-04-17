class ChecklistitemsController < ApplicationController
   before_filter :login_marshall

  def new
    @checklist = Checklist.find(params[:checklist_id])
    @checklistitem = @checklist.checklistitems.build
    respond_to do |format|
      format.js
    end
  end

  def create
    @checklist = Checklist.find(params[:checklist_id])
    @checklistitem = @checklist.checklistitems.create(params[:checklistitem])
    respond_to do |format|
      if @checklistitem.save
        @checklistitems = Checklistitem.find_all_by_checklist_id(params[:checklist_id])
        format.js
      end
    end
  end


end
