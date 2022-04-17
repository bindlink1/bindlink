class DocumentsController  < ApplicationController
  layout 'applicationfunctional'
  before_filter :login_marshall


  before_filter :only => ["update", "edit", "destroy", "download",  "editlist", "updatelist"] do |bf|
    document = Document.find(params[:id])
    if current_agent.isgeneralagent =="GA"
      bf.permission_marshall(document.generalagency_id)
    else
      bf.permission_marshall(document.agency_id)
    end
  end


  def createnewdocument
    @document = Document.new( params[:document] )
    if current_agent.isgeneralagent =="GA"
      @document.generalagency_id = current_agent.generalagency_id
    else
      @document.agency_id = current_agent.agency_id
    end
    if params[:type] == 'policy'
      @document.policy_id = params[:id]
    elsif params[:type] == 'client'
      @document.client_id = params[:id]
    elsif params[:type] == 'producer'
      @document.producingagency_id = params[:id]
    elsif params[:type] == 'quote'
      @document.quote_id = params[:id]
    elsif params[:type] == 'submission'
      @document.submission_id = params[:id]
    end

    @document.doctype = ( [ "Endorsements", "Claims" ].include? params[:doctype] ) ? params[:doctype] : nil

    @document.save
    if @document.save
      if params[:type] == 'policy'
        @documentsforview = Document.where( "policy_id = ?", params[:id] ).order( "created_at DESC" )
        unless params[:doctype].blank?
          @documentsforview = @documentsforview.where DocumentsController.getdoctypecondition params[:doctype]
        end
      elsif params[:type] == 'client'
        @documentsforview = Document.order("created_at DESC").find_all_by_client_id(params[:id])
      elsif params[:type] == 'producer'
        @documentsforview = Document.order("created_at DESC").find_all_by_producingagency_id(params[:id])
      elsif params[:type] == 'quote'
        @documentsforview = Document.order("created_at DESC").find_all_by_quote_id(params[:id])
      elsif params[:type] == 'submission'
        @documentsforview = Document.order("created_at DESC").find_all_by_submission_id(params[:id])
      end

      respond_to do |format|
        format.js { render :content_type => "text/plain" }
      end
    else
      render :action => 'new'
    end
  end


  def new
    @document = Document.new
    @id = params[:id]
    @type = params[:type]
    @doctype = params[:doctype]
  end


  def create
    @document = Document.new( params[:document] )
    @document.save
    if @document.save
      flash[:notice] = "Successfully created document."
      redirect_to @document
    else
      render :action => 'new'
    end
  end


  def destroy
    @document = Document.find(params[:id])

    if !@document.policy_id.nil?
      @policy = Policy.find(@document.policy_id)
    end

    @document.destroy
    respond_to do |format|
      if !@policy.blank?
        @documentsforview = Document.find_all_by_policy_id(@policy.id)

        if !@policy.quote_id.nil?
          @quotedocumentsforview = Document.find_all_by_quote_id(@policy.quote_id)
          @submissiondocumentsforview = Document.find_all_by_submission_id(@policy.quote.submission_id)
        end
      end

      format.js
    end
  end


  def edit
    @document = Document.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def editlist
    @document = Document.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def update
    @document = Document.find(params[:id])

    respond_to do |format|
      if @document.update_attributes(params[:document])
        format.js
      end
    end
  end


  def updatelist
    @document = Document.find(params[:id])
    respond_to do |format|
      if @document.update_attributes(params[:document])
        format.js
      end
    end
  end


  def self.getdoctypecondition doctype
    cond = ""
    if doctype == "Endorsements"
      cond = "doctype = 'Endorsements'"
    elsif doctype == "Claims"
      cond = "doctype = 'Claims'"
    elsif doctype == "other"
      cond = "doctype IS NULL"
    end
    cond
  end


  def showgrid
    if params[:type] == 'policy'
      @policyforview = Policy.find(params[:id])
      @documentsforview = Document.where( "policy_id = ?", params[:id] ).order( "created_at DESC" )
      unless params[:doctype].blank?
        @documentsforview = @documentsforview.where DocumentsController.getdoctypecondition params[:doctype]
      end

      if !@policyforview.quote_id.nil?
        @quotedocumentsforview = Document.find_all_by_quote_id(@policyforview.quote_id)
        if !@policyforview.quote.submission_id.nil?
          @submissiondocumentsforview = Document.find_all_by_submission_id(@policyforview.quote.submission_id)
        end
      end
    elsif params[:type] == 'client'
      @documentsforview = Document.find_all_by_client_id(params[:id])
    elsif params[:type] == 'producer'

      @documentsforview = Document.find_all_by_producingagency_id(params[:id])
    elsif params[:type] == 'quote'

      @documentsforview = Document.find_all_by_quote_id(params[:id])
    elsif params[:type] == 'submission'

      @documentsforview = Document.find_all_by_submission_id(params[:id])
      @submission = 1
    end

    respond_to do |format|
      format.js
    end
  end


  def showlist
    if params[:type] == 'policy'
      @policyforview = Policy.find(params[:id])
      @documentsforview = Document.where( "policy_id = ?", params[:id] ).order( "created_at DESC" )
      unless params[:doctype].blank?
        @documentsforview = @documentsforview.where( DocumentsController.getdoctypecondition params[:doctype] )
      end

      if !@policyforview.quote_id.nil?
        @quotedocumentsforview = Document.find_all_by_quote_id(@policyforview.quote_id)
        if !@policyforview.quote.submission_id.nil?
          @submissiondocumentsforview = Document.find_all_by_submission_id(@policyforview.quote.submission_id)
        end
      end
    elsif params[:type] == 'client'
      @documentsforview = Document.find_all_by_client_id(params[:id])
    elsif params[:type] == 'producer'


      @documentsforview = Document.find_all_by_producingagency_id(params[:id])
    elsif params[:type] == 'quote'

      @documentsforview = Document.find_all_by_quote_id(params[:id])
    elsif params[:type] == 'submission'

      @documentsforview = Document.find_all_by_submission_id(params[:id])
      @submission = 1
    end

    respond_to do |format|
      format.js
    end
  end

  def download
    @documentsforview = Document.find(params[:id])
    redirect_to @documentsforview.image.expiring_url(10)
  end

end