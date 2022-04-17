class NamedinsuredsController < ApplicationController
  layout 'applicationfunctional'
  before_filter :login_marshall
  set_tab :namedinsuredhome, :sidenav, :only => %w(index)
  def index
    @namedinsureds = Namedinsured.find_all_by_generalagency_id(current_agent.generalagency_id)
  end


  def show
    @namedinsured = Namedinsured.find(params[:id])
    @policiesfornamedinsureds = Policy.order("effective_date DESC").find_all_by_namedinsured_id(params[:id])
    @submissions = Submission.find_all_by_namedinsured_id(params[:id])
  end

  def edit
    @namedinsured = Namedinsured.find(params[:id])
  end

  def update
     @namedinsured = Namedinsured.find(params[:id])
        respond_to do |format|
      if @namedinsured.update_attributes(params[:namedinsured])
        @namedinsured = Namedinsured.find(params[:id])
        format.js

      end

    end
  end
end
