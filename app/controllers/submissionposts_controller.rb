class SubmissionpostsController < ApplicationController



   def create
       @allconversations = Conversation.find_all_by_submission_id($currentsubmission)

       if $isfollowup == 0  then
         @conversation = Conversation.new

         #create if statement here to save agency/QE info depending on what type of user is logged in
        if agent_signed_in?
          @conversation.agency_id = current_agent.agency_id
          @conversation.agent_id = current_agent.id
        elsif underwriter_signed_in?
          @conversation.quotingentity_id = current_underwriter.quotingentity_id
          @conversation.underwriter_id = current_underwriter.id
        end


          @conversation.submission_id = $currentsubmission
          @conversation.save!

          @submissionthread = Submissionthread.new
          @submissionthread.conversation_id = @conversation.id

          @submissionthread.save!

          $submissionthreadid = @submissionthread.id

        end



    @submissionpost = Submissionpost.new(params[:submissionpost])
    @submissionpost.submissionthread_id =  $submissionthreadid

     if agent_signed_in?
        @submissionpost.agent_id = current_agent.id

        elsif underwriter_signed_in?
          @submissionpost.underwriter_id = current_underwriter.id
      end


    respond_to do |format|
        if @submissionpost.save
        #flash[:notice] = "Thanks for adding a new post!"
          $submissionpostthreadid = @submissionpost.submissionthread_id
          @conversationidST = Submissionthread.find($submissionpostthreadid)
          @thisconversation = Conversation.find(@conversationidST.conversation_id)
          @submissionpost.submissionposttext.clear

          format.js
          #format.html { redirect_to(view_submission_path(:id =>submission.id)) ,:notice=> 'Submission Post was successfully created.') }

          #format.json { render json: @submissionpost, status: :created, location: @submissionpost }
        else
           format.html { redirect_to(@submissionpost)}
          format.html { render action: "new" }
          format.json { render json: @submissionpost.errors, status: :unprocessable_entity }
        end
    end

   end


end

