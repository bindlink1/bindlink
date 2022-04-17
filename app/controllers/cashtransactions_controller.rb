class CashtransactionsController < ApplicationController

  layout 'applicationfunctional'
  before_filter :login_marshall
  set_tab :bulkentry, :sidenav, :only => %w(show)
  set_tab :returnpremium, :sidenav, :only => %w(returnhome)
  set_tab :compay, :sidenav, :only => %w(compayhome)

  def createfrominvoice
    params[:cashtransaction][:cash_amount] = (params[:cashtransaction][:cash_amount]).gsub( /[^\d.]/,'').to_f
    params[:cashtransaction][:transaction_effective_date] = Date.strptime(params[:cashtransaction][:transaction_effective_date], '%m/%d/%Y')

    @cashtransaction = Cashtransaction.new(params[:cashtransaction])
    Cashtransaction.new.applypayment(params[:id], @cashtransaction.cash_amount.round(2),"no" , current_agent.id, @cashtransaction.check_number, params[:cashtransaction][:transaction_effective_date], "")
    @cashtransactions = Cashtransaction.find_all_by_invoice_id(params[:id])
    @invoice = Invoice.find(params[:id])
    respond_to do |format|
      format.js
    end

  end

  def createfrombulk



    @cashtransaction = Cashtransaction.new
    @cashtransaction = Cashtransaction.new(params[:cashtransaction])

    Cashtransaction.new.applypayment($currentinvoice, @cashtransaction.cash_amount, "yes" , current_agent.id)
    @cashtransactions = Cashtransaction.find_all_by_invoice_id($currentinvoice)
    respond_to do |format|
      format.js
    end
  end

  def enternsf
    @cashtransaction = Cashtransaction.find(params[:id])
    @cashtransaction.reversecash("nsf")
    @invoice= Invoice.find(@cashtransaction.invoice_id)
    @policy = Policy.find(@cashtransaction.invoice.policypremiumtransaction.policy_id)
    @cashtrans = Cashtransaction.find_all_by_invoice_id(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def voidpayment
    @cashtransaction = Cashtransaction.find(params[:id])
    @cashtransaction.reversecash("void")
    @invoice= Invoice.find(@cashtransaction.invoice_id)
    @policy = Policy.find(@cashtransaction.invoice.policypremiumtransaction.policy_id)
    @cashtrans = Cashtransaction.find_all_by_invoice_id(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def transfercash
    @cashtransaction = Cashtransaction.find(params[:id])

    carrierlist
    respond_to do |format|
      format.js
    end

  end

  def processtransfercash
    @invoice = Invoice.find(params[:id])
    @cashtransaction = Cashtransaction.find(params[:cid])



    Cashtransaction.new.applypayment(@invoice.id, @cashtransaction.cash_amount, "no", current_agent.id, @cashtransaction.check_number, @cashtransaction.transaction_effective_date, "yes")
    @cashtransaction.reversecash("transfer", @invoice.policypremiumtransaction.policy.policy_number)
    respond_to do |format|
      format.js
    end

  end

  def carrierlist
    @carriers = Carrier.find_all_by_generalagency_id(current_agent.generalagency_id)
  end


  def show
    carrierlist

  end

  def entercash


    $currentinvoice = params[:id]
    @cashtransaction = Cashtransaction.new
    respond_to do |format|
      format.js
    end
  end
  def compayhome


    @compaybatches = CompayBatch.where("status ='Done'").find_all_by_generalagency_id(current_agent.generalagency_id)
    @open = CompayBatch.where(" status='Open'").find_all_by_generalagency_id(current_agent.generalagency_id)
    @unprocessed = CompayBatch.where("status='Processing' OR status='Ready'").find_all_by_generalagency_id(current_agent.generalagency_id)

  end
  def returnhome

    if current_agent.isgeneralagent == "GA"
      @returnbatches = ReturnPremiumBatch.where("status ='Done'").order( "id desc" ).find_all_by_generalagency_id(current_agent.generalagency_id)
      @open = ReturnPremiumBatch.where(" status='Open'").order( "id desc" ).find_all_by_generalagency_id(current_agent.generalagency_id)
      @unprocessed = ReturnPremiumBatch.where("status='Processing' OR status='Ready'").order( "id desc" ).find_all_by_generalagency_id(current_agent.generalagency_id)
    else

      @returnbatches = ReturnPremiumBatch.where("status ='Done'").find_all_by_agency_id(current_agent.agency_id)
    end

  end
  def viewreturnbatchpre
    @returnbatch = ReturnPremiumBatch.find(params[:id])

  end
  def viewcompaybatchpre
    @compaybatch = CompayBatch.find(params[:id])

  end
  def viewreturnbatch
    @returnbatch = ReturnPremiumBatch.find(params[:id])

  end
  def viewcompaybatch
    @compaybatch = CompayBatch.find(params[:id])

  end


  def editreturnbatch
    @returnbatch = ReturnPremiumBatch.find(params[:id])
  end


  def printinvoicesunprocessed
    @returnbatch = ReturnPremiumBatch.find(params[:id])

    @invoices = Invoice.joins( "\n\
        JOIN policypremiumtransactions ppt ON invoices.policypremiumtransaction_id = ppt.id \n\
        JOIN returnpremiumbatchpreitems i ON i.policy_id = ppt.policy_id \n" ).
      where( "i.return_premium_batch_id = ? ", @returnbatch.id ).order("i.id")

    pdf = CombinePDF.new("electronicpayment.pdf")
    f = true
    @invoices.each do |inv|
      if inv.outstandingbalance.abs > 0.01 
        pp = CombinePDF.parse(InvoicePdf.new(inv).render)
        if f then
          pdf = pp
          f = false
        else
          pdf << pp
        end
      end
    end

    if f then
      s = "No invoices for selected batch"
      render text: s, content_type: 'text/html'
    else
      datetime = DateTime.now
      send_data pdf.to_pdf, filename: "invoices_batch_print_#{datetime.to_s(:number)}.pdf",
                    type: "application/pdf",
                    disposition: "inline"
    end
  end


  def printinvoicesprocessed
    @returnbatch = ReturnPremiumBatch.find(params[:id])

    @invoices = Invoice.joins( "\n\
        JOIN cashtransactions ct ON invoices.id = ct.invoice_id \n\
        JOIN returnpremiumbatchitems i ON i.id = ct.returnpremiumbatchitem_id \n" ).
      where( "i.return_premium_batch_id = ? ", @returnbatch.id ).order("i.id")

    pdf = CombinePDF.new("electronicpayment.pdf")
    f = true
    @invoices.each do |inv|
      pp = CombinePDF.parse(InvoicePdf.new(inv).render)
      if f then
        pdf = pp
        f = false
      else
        pdf << pp
      end
    end

    if f then
      s = "No invoices for selected batch"
      render text: s, content_type: 'text/html'
    else
      datetime = DateTime.now
      send_data pdf.to_pdf, filename: "invoices_batch_print_#{datetime.to_s(:number)}.pdf",
                    type: "application/pdf",
                    disposition: "inline"
    end
  end


  def deletereturnpremiumbatch
    @returnbatch = ReturnPremiumBatch.find(params[:id])
    @returnbatch.destroypreitems
    @returnbatch.destroy
    render text: "<script>location.href = \"/returnhome\";</script>", content_type: 'text/html'
  end


  def editcompaybatch
    @compaybatch = CompayBatch.find(params[:id])

  end

  def editreturncheck
    returnitem = Returnpremiumbatchitem.find(params[:id])
    returnchecks = Cashtransaction.where("returnpremiumbatchitem_id = ?", returnitem.id)
    @returncheck = returnchecks[0]
    respond_to do |format|
      format.js
    end

  end

  def editcompaycheck
    compayitem = Compaybatchitem.find(params[:id])
    compaychecks = Cashtransaction.where("compaybatchitem_id = ?", compayitem.id)
    @compaycheck = compaychecks[0]
    respond_to do |format|
      format.js
    end

  end
  def updatecompaycheck
    @compaycheck = Cashtransaction.find(params[:id])
    @compaybatch = CompayBatch.find(@compaycheck.compaybatchitem.compay_batch_id)
    respond_to do |format|
      if  @compaycheck.update_attributes(params[:cashtransaction])

        format.js

      end

    end
  end
  def updatereturncheck
    @returncheck = Cashtransaction.find(params[:id])
    @returnbatch = ReturnPremiumBatch.find(@returncheck.returnpremiumbatchitem.return_premium_batch_id)
    respond_to do |format|
      if  @returncheck.update_attributes(params[:cashtransaction])

        format.js

      end

    end
  end

  def printsinglereturncheck

    @returncheck = Cashtransaction.find(params[:id])


    respond_to do |format|

      format.pdf do
        pdf = SinglereturncheckPdf.new(@returncheck)
        send_data pdf.render, filename: "returncheck",
                  type: "application/pdf",
                  disposition: "inline"
      end

    end


  end

  def printsinglecompaycheck

    @compaycheck = Cashtransaction.find(params[:id])


    respond_to do |format|

      format.pdf do
        pdf = SinglecompaycheckPdf.new(@compaycheck)
        send_data pdf.render, filename: "compaycheck",
                  type: "application/pdf",
                  disposition: "inline"
      end

    end


  end

  #first step in commission payable workflow - creates new batch and calls delayed_job Generatecompaylist,
  #sets status of batch to 'processing' until delayed_job is completed.
  def createcompaybatch
    compaybatch = CompayBatch.new
    compaybatch.status = 'Processing'
    compaybatch.generalagency_id = current_agent.generalagency_id
    compaybatch.save

    @unprocessed = CompayBatch.where("status='Processing' OR status='Ready'").find_all_by_generalagency_id(current_agent.generalagency_id)
    Delayed::Job.enqueue Generatecompaylist.new(compaybatch.id,current_agent.generalagency_id)
    respond_to do |format|
      format.js
    end
  end

  def compaylist
    @compaybatch = CompayBatch.find(params[:id])
    @compay = Compaybatchpreitem.find_all_by_compay_batch_id(params[:id])
  end

  #first step in return premium workflow - creates new batch and calls delayed_job Generatereturnlist,
  #sets status of batch to 'processing' until delayed_job is completed.
  def createreturnbatch
    rpb = ReturnPremiumBatch.new
    rpb.createbatch(current_agent.generalagency_id)
    @unprocessed = rpb.getunprocessed(current_agent.generalagency_id)


    respond_to do |format|
      format.js
    end
  end
  def returnlist
    @returnbatch = ReturnPremiumBatch.find(params[:id])
    @return = Returnpremiumbatchpreitem.find_all_by_return_premium_batch_id(params[:id])
  end

  def selectedreturn

    @policy = Policy.find(params[:id])


    respond_to do |format|
      format.js
    end

  end


  ## IS THIS STILL USED?
  def processreturn
    @policy = Policy.find(params[:id])

    begin
      Cashtransaction.new.applyreturn( @policy.policybalance, "Return", "yes", @policy.agent_id, @policy.id )
      @returnresult = "Return Successful!"
    rescue
      @returnresult = "Return Failed!"
    end

    respond_to do |format|
      format.js
    end
  end

  def paycompay

    @compaybatch = CompayBatch.find(params[:id])
    @compaybatch.status = 'Open'
    @compaybatch.save


    params[:compay][:policy_ids].each do |retpols|
      poltemp = Policy.find(retpols)
      @batchitems = Compaybatchitem.new
      @batchitems.compay_batch_id = @compaybatch.id
      @batchitems.policy_id = retpols
      @batchitems.producingagency_id = poltemp.producingagency_id
      @batchitems.save
    end
    respond_to do |format|
      format.js
    end

  end


  #used in commission payable function
  def processcompaybatch
    @compaybatch = CompayBatch.find(params[:id])

    #removed this as GIC is not printing checks anymore
    #checkstart = params[:compay_batch][:check_start].to_f
    #checkend = params[:compay_batch][:check_end]


    @compaybatch.compaybatchitems.each do |cp|

      if cp.policy.accountbalance(20005, 'Liability')>0
        Cashtransaction.new.compaywork( cp.policy.accountbalance(20005, 'Liability'),   cp.policy.id,  cp.id, "ACH Payment " + Date.today.to_s , cp.producingagency_id, "outward")
      end


      if cp.policy.accountbalance(10004, 'Asset')>0
        Cashtransaction.new.compaywork( cp.policy.accountbalance(10004, 'Asset'),   cp.policy.id,  cp.id, "ACH Withdrawal " + Date.today.to_s , cp.producingagency_id, "inward")
      end

    end

    @compaybatch.status = 'Done'
    @compaybatch.save
    @compaybatch.delay.destroypreitems

    respond_to do |format|
      format.js
    end
  end

  def printcompaycheck


    @compaybatch = CompayBatch.find(params[:id])


    respond_to do |format|

      format.pdf do
        pdf = CompaycheckPdf.new(@compaybatch)
        send_data pdf.render, filename: "compaycheck",
                  type: "application/pdf",
                  disposition: "inline"
      end

    end


  end


  def returnpremium

    @returnbatch = ReturnPremiumBatch.find(params[:id])
    @returnbatch.status = 'Open'
    @returnbatch.save




    params[:return][:policy_ids].each do |retpols|
      @batchitems = Returnpremiumbatchitem.new
      @batchitems.return_premium_batch_id = @returnbatch.id
      @batchitems.policy_id = retpols

      if !params[:return][:policy_payto][retpols].nil?

        @batchitems.pay_to_entity = params[:return][:policy_payto][retpols.to_sym].to_s
        if params[:return][:policy_payto][retpols.to_sym]  == "PFC"
          @batchitems.pfc_id = @batchitems.policy.pfc_id

        elsif params[:return][:policy_payto][retpols.to_sym]  == "ProducingAgency"
          @batchitems.producingagency_id = @batchitems.policy.producingagency_id
        end
      else
        @batchitems.pay_to_entity  = "ProducingAgency"
        @batchitems.producingagency_id = @batchitems.policy.producingagency_id

      end


      @batchitems.save
    end
    respond_to do |format|
      format.js
    end

  end

  #used in return premium function
  def processreturnbatch
    @returnbatch = ReturnPremiumBatch.find(params[:id])


    checkstart = params[:return_premium_batch][:check_start].to_f
    checkend = params[:return_premium_batch][:check_end]


    @returnbatch.returnpremiumbatchitems.each do |ret|
      # not cascading payment - waiting for noninvoice cash
      Cashtransaction.new.applyreturn( ret.policy.policybalance, "Return", "no", ret.policy.agent_id, ret.policy.id, ret.id, checkstart.round.to_s, ret.producingagency_id, ret.pfc_id)

      checkstart = checkstart + 1


    end

    @returnbatch.status = 'Done'
    @returnbatch.save
    @returnbatch.delay.destroypreitems
  end
  def printreturncheck

    # @policy = Policy.find(params[:id])
    @returnbatch = ReturnPremiumBatch.find(params[:id])


    respond_to do |format|

      format.pdf do
        pdf = ReturncheckPdf.new(@returnbatch)
        send_data pdf.render, filename: "returncheck",
                  type: "application/pdf",
                  disposition: "inline"
      end

    end


  end


  def retprintsuccess
    @returnbatch = ReturnPremiumBatch.find(params[:id])
    @returnbatch.status = 'Done'
    @returnbatch.save

    redirect_to returnhome_path
  end

  def compayprintsuccess
    @compaybatch = CompayBatch.find(params[:id])
    @compaybatch.status = 'Done'
    @compaybatch.save

    redirect_to compayhome_path
  end

  def enterunearnedcommcheck
    @policy = Policy.find(params[:id])
    @cashtransaction = Cashtransaction.new
  end

  def unearnedcommissionpay
    @cashtransaction = Cashtransaction.new(params[:cashtransaction])
    @cashtransaction.transaction_type = "Unearned Commission"
    @cashtransaction.save

    @cashtransaction.processunearnedcommissionpayment
  end



end
