class ConversationsController < ApplicationController




  def createconversation



      respond_to do |format|

=begin
          @conversation = Conversation.new
          @conversation.quotingentity_id = current_underwriter.quotingentity_id
          @conversation.submission_id = $currentsubmission
          @conversation.underwriter_id = current_underwriter.id

          @conversation.save!

          @submissionthread = Submissionthread.new
          @submissionthread.conversation_id = @conversation.id

          @submissionthread.save!

          $submissionthreadid = @submissionthread.id
=end
          $isfollowup = 0
          @submissionpost = Submissionpost.new
          $thisconversationid = 0
          format.js



      end
  end

=begin
  def new
    @submissionpost = Submissionpost.new

    respond_to do |format|
      format.html # _new.html.erb
      format.json { render json: @submissionpost }
    end
  end


  def createsubmissionpost
    @submissionpost = Submissionpost.new

    respond_to do |format|
      format.js
    end

  end
=end

    def createsubmissionpostfollowup
    $isfollowup = 1

    $thisconversationid = Submissionthread.find(params[:id])

    @submissionpostfollow = Submissionpost.new
    $submissionthreadid = (params[:id])

    respond_to do |format|
      format.js
    end

  end

end
