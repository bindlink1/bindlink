class InvoicesController < ApplicationController
  layout 'applicationfunctional'
  before_filter :login_marshall
  set_tab :invoices
  set_tab :invoicehome, :sidenav


  def edit
    @invoice = Invoice.find(params[:id])
  end

  def update
    @invoice = Invoice.find(params[:id])
    @invoice.update_attributes(params[:invoice])
  end


  def view
    #TODO create security measure that prevents agent to show invoices that are not associated with their agency
    @invoiceforview = Invoice.find(params[:id])
    $currentinvoice = @invoiceforview.id

    @cashtransactions = Cashtransaction.find_all_by_invoice_id($currentinvoice)
  end

  def show

    if current_agent.isgeneralagent == "Retail"
      @invoices = Invoice.find_all_by_agency_id(current_agent.agency_id)
    else
      @invoices = Invoice.find_all_by_generalagency_id(current_agent.generalagency_id)
    end



    @odlist = Array.new

    @invoices.each do |overdue|
      if overdue.isoverdue == "Overdue"
        @odlist << overdue
      end
    end

  end


  def createfrompolicy
    @invoice = Invoice.new
    @invoice = Invoice.new(params[:invoice])
    @invoice.policy_id = $currentpolicy

    if current_agent.isgeneralagent == "Retail"
      @invoice.agency_id = $currentagent
    else
      @invoice.generalagency_id = $currentagent
      @invoice.producingagency_id = $currentproducer
    end

    respond_to do |format|
      if @invoice.save

        # @accountingevent = Accountingevent.new

        # @accountingevent.transaction_type = "New"
        # @accountingevent.total_billed = @invoice.total_billed
        # @accountingevent.commission = @invoice.commission
        # @accountingevent.invoice_id = @invoice.id
        # @accountingevent.created_date = @invoice.created_at
        # @accountingevent.agency_id = current_agent.agency_id   = we dont need agency id for an invoice
        # @accountingevent.carrier_id = $currentcarrier
        # @accountingevent.recordaccountingevent

        format.js
      else
        format.js
        #format.html { redirect_to(@client)}
        #format.html { render action: "new" }
        #format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end


  def entercash

  end


  def destroy
    @invoice = Invoice.find(params[:id])
    ppt = @invoice.policypremiumtransaction
    puts "ppt.producercommissions"
    puts ppt.producercommissions
    puts ppt.id
    ppt.producercommissions.each do | x |
      x.destroy
    end
    ppt.feetransactions.each do | x |
      x.destroy
    end
    ppt.accountingtransactions.each do | x |
      x.destroy
    end
    @invoice.destroy
    ppt.destroy

    respond_to do |format|
      format.js
    end
  end
end
