class EmailsController < ApplicationController
  def new
    @email = Email.new
    @emailaddress = Agent.find(current_agent.id)
    @templates = MessageTemplate.all()
   
    if params[:invoice].nil?
      @documents = []
      @document = Document.find(params[:document])
      @documents[0] = @document

      if !@document.policy_id.nil?
        @policy = Policy.find(@document.policy_id)
        @carrieremail = @policy.carrier.underwriting_email
      else
        if !@document.quote_id.nil?
          @policy = Quote.find(@document.quote_id)
          @carrieremail = @policy.carrier.underwriting_email
          @policy = @policy.submission
        end
      end

      @invoice = "none"

    else
      @invoice = Invoice.find(params[:invoice])
      @policy = Policy.find(@invoice.policypremiumtransaction.policy_id)
      @carrieremail = @policy.carrier.underwriting_email
    end

    respond_to do |format|
      format.js
    end
  end

  def index
    if current_agent.isgeneralagent == "Retail"
      agencyid = current_agent.agency_id
      agencyt = "Retail"
    else
      agencyid = current_agent.generalagency_id
      agencyt = "GA"
    end

    respond_to do |format|
      format.html
      format.json  { render json: EmailsDatatable.new(view_context, current_agent) }
    end
  end


  def sendalldocs
    @email = Email.new
    @templates = MessageTemplate.all()

    if params[:type] == 'policy'
      @documents = Document.where( "policy_id = ?", params[:id] ).order( "created_at DESC" )
      unless params[:doctype].blank?
        @documents = @documents.where DocumentsController.getdoctypecondition params[:doctype]
      end
      @policy = Policy.find(params[:id])
      @carrieremail = @policy.carrier.underwriting_email
    elsif params[:type] == 'client'
      @documents = Document.find_all_by_client_id(params[:id])
    elsif params[:type] == 'producer'
      @documents = Document.find_all_by_producingagency_id(params[:id])
    elsif params[:type] == 'quote'
      @documents = Document.find_all_by_quote_id(params[:id])
      @policy = Quote.find(params[:id])
      @carrieremail = @policy.carrier.underwriting_email
      @policy = @policy.submission
    elsif params[:type] == 'submission'
      @documents = Document.find_all_by_submission_id(params[:id])
    end

    @emailaddress = Agent.find(current_agent.id)
  end


  def createdocemail
    @email = Email.new(params[:email])

    respond_to do |format|
      if !params[:documents].nil?
        id = params[:documents][0]
        @email.document_id = id
      end
      if @email.save
        if params[:invoice].nil?
          Outboundemail.senddocument(params[:email][:from],params[:email][:to],params[:email][:subject],params[:email][:body],params[:documents]).deliver
        else
          invoice = Invoice.find(params[:invoice])
          pdf = InvoicePdf.new(invoice)
          Outboundemail.sendinvoice(params[:email][:from],params[:email][:to],params[:email][:subject],params[:email][:body],invoice.policypremiumtransaction.policy.policy_number,pdf).deliver
        end

        format.js
      end
    end
  end

  def createdocmultipleemail
    @email = Email.new(params[:email])

    @email.document_id = id

    respond_to do |format|
      if @email.save
        Outboundemail.senddocument(params[:email][:from],params[:email][:to],params[:email][:subject],params[:email][:body],params[:documents]).deliver
        format.js
      end
    end
  end
end