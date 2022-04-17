class NotesController < ApplicationController
  before_filter :login_marshall

  def new
    if  !params[:policy_id].nil?
      @policy = Policy.find(params[:policy_id])
      @note = @policy.notes.build
    elsif !params[:client_id].nil?
      @client = Client.find(params[:client_id])
      @note = @client.notes.build
    elsif !params[:quote_id].nil?
      @quote = Quote.find(params[:quote_id])
      @note = @quote.notes.build
    end

    respond_to do |format|
      format.js
    end
  end


  def create
    if !params[:quote_id].nil?
      @quote = Quote.find(params[:quote_id])
      params[:note][:agent_id] = current_agent.id.to_s
      @note = @quote.notes.create(params[:note] )
    elsif !params[:client_id].nil?
      @client = Client.find(params[:client_id])
      params[:note][:agent_id] = current_agent.id.to_s
      @note = @client.notes.create(params[:note] )
    elsif !params[:submission_id].nil?
      @submission = Submission.find(params[:submission_id])
      params[:note][:agent_id] = current_agent.id.to_s
      @note = @submission.notes.create(params[:note] )
    elsif !params[:policy_id].nil?
      @policy = Policy.find(params[:policy_id])
      params[:note][:agent_id] = current_agent.id.to_s
      @note = @policy.notes.create(params[:note] )
    elsif !params[:producingagency_id].nil?
      @producer = Producingagency.find(params[:producingagency_id])
      params[:note][:agent_id] = current_agent.id.to_s
      @note = @producer.notes.create(params[:note] )
    end

    if current_agent.isgeneralagent == "GA"
      @note.generalagency_id = current_agent.generalagency_id
    else
      @note.agency_id = current_agent.agency_id
    end

    respond_to do |format|
      if @note.save
        @quotenotesforview = 0
        if !params[:quote_id].nil?
          @notesforview = Note.find_all_by_quote_id(@quote,:order => "id desc")
        elsif !params[:client_id].nil?
          @notesforview = Note.find_all_by_client_id(@client,:order => "id desc")
        elsif !params[:submission_id].nil?
          @notesforview = Note.find_all_by_submission_id(@submission,:order => "id desc")
        elsif !params[:policy_id].nil?
          @notesforview = Note.find_all_by_policy_id(@policy,:order => "id desc")
          if !@policy.quote_id.nil?
            @quotenotesforview = Note.order("created_at DESC").find_all_by_quote_id(@policy.quote_id)
          end
        elsif !params[:producingagency_id].nil?
          @notesforview = Note.find_all_by_producingagency_id(@producer,:order => "id desc")
        end

        format.js
      end
    end
  end


  def infinitenotes

    if current_agent.isgeneralagent == "Retail"

      @notesforview = Note.find_all_by_agency_id(current_agent.agency_id , :order => "id desc")
      @notespaginate = Kaminari.paginate_array(@notesforview).page(params[:page]).per(10)
    else

      @notesforview = Note.find_all_by_agency_id(current_agent.agency_id , :order => "id desc")
      @notespaginate = Kaminari.paginate_array(@notesforview).page(params[:page]).per(10)
    end

    respond_to do |format|
      format.js
    end
  end







end
