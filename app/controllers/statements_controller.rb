
class StatementsController < ApplicationController

  before_filter :login_marshall
  layout 'applicationfunctional'
  set_tab :statementrecon, :sidenav


  def index
    @statement = Statement.new
    @agencymaster = Agencymaster.new(current_agent.id)
  end

  def reconcilestatement
    @statement = Statement.new(params[:statement])
    @statement.agent_id = current_agent.id
    @statement.start_date = Date.strptime(params[:statement][:start_date].to_s, '%m/%d/%Y')
    @statement.end_date =Date.strptime(params[:statement][:end_date].to_s, '%m/%d/%Y')

  end

  def import


    spreadsheet = Statement.open_spreadsheet(params[:file])
    header = spreadsheet.row(1)
    @missing = Array.new
    @missingflag = false
    (2..spreadsheet.last_row).each do |i|
      c = Policy.where("policy_number = ?",spreadsheet.cell('A',i)).count
      if c == 0
        @missing << spreadsheet.cell('A',i)
        @missingflag = true
      end
    end

    if @missingflag == false
      (2..spreadsheet.last_row).each do |i|
        c = Policy.where("policy_number = ?",spreadsheet.cell('A',i)).first
          ppt = Policypremiumtransaction.new

          ppt.gadirectbillrecoprocess(c.id, spreadsheet.cell('B',i))

      end
    end

  end

  def processreconciliation
    statement = Statement.new(params[:statement])


    if params[:commit] == "Process"
      Policypremiumtransaction.new.processreconciliation(params[:statement][:ppt_ids], statement.id)
      statement.status = 'Processed'
    else
      statement.status = 'Open'
    end
    statement.save
    begin
      Statementitem.new.addppt(params[:statement][:ppt_ids], statement.id)
    rescue
    end

    redirect_to statements_path
  end

  def selectedpolicyentry
    @policy = Policy.find(params[:id])

  end

  def recordentry
    ppt = Policypremiumtransaction.new
    ppt.gadirectbillrecoprocess(params[:id], params[:recoamount])
  end

  def processreconciliationentries

  end



  def show
    @statement= Statement.find(params[:id])
  end


end
