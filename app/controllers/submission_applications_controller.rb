class SubmissionApplicationsController < ApplicationController

    def new
        @submissionapplication= SubmissionApplication.new
        @doc = Nokogiri::XML(File.open("bindlinkapp1.xml"))

        @formfieldarray = Array.new

        @doc.xpath("//appfield").each do |node|
                          @formfields = Submissionappfield.new


                          @formfields.display_name = node.xpath('field_name/@display_name').text
                          @formfields.field_type = node.xpath('field_type').text
                          if node.xpath('required').text == "Yes"
                             @reqclass = "formrequired"
                          else
                             @reqclass = "formnotrequired"
                          end
                          @formfields.required =  @reqclass
                          @formfields.field_name = node.xpath('field_name').text
                          if @formfields.field_type =="drop_down" || "radio" || "checkbox"
                            node.xpath("options/option").each do |options|
                              @formfields.field_options << options.text
                            end
                          end
                          @formfieldarray << @formfields

        end
      respond_to do |format|
        format.html # _new.html.erb
        format.json { render json: @submissionapplication }
      end
    end

    def create

    @doc = Nokogiri::XML(File.open("bindlinkapp1.xml"))

    @applicationarray = Array.new
    @errorarray = Array.new



    @doc.xpath("//appfield").each do |node|
      #@submissionapplicationfield = SubmissionApplication.new(params[:submission_application])

      if node.xpath('field_type').text == 'checkbox'
          @checkboxarray = Array.new
          @checkboxselected = 0
          @tempsymbol ="response" + node.xpath('field_name').text
          #loop through the different options in the check box group
          params[@tempsymbol.to_sym ][:response].each do  |checkboxparam|
            @submissionapplicationfield = SubmissionApplication.new
            @submissionapplicationfield.field_name = node.xpath('field_name').text
            @submissionapplicationfield.response =checkboxparam.to_s #checkboxparam.to_s #params["response" + node.xpath('field_name').text]

            if  checkboxparam.blank?
                #modified for checkbox
                if  node.xpath('required').text == 'Yes'
                  @checkboxarray << @submissionapplicationfield
                end

            else
            @applicationarray << @submissionapplicationfield
              @checkboxselected = 1
            end
          end


           if  node.xpath('required').text == 'Yes'
               if @checkboxselected ==0  then

                   @errorarray << @submissionapplicationfield
               end
           end

      else
          #need to cleanup in the future...for now, this will do

            @submissionapplicationfield = SubmissionApplication.new
            @submissionapplicationfield.field_name = node.xpath('field_name').text
            @submissionapplicationfield.response =params["response" + node.xpath('field_name').text]

            if  @submissionapplicationfield.response.blank?
                if  node.xpath('required').text == 'Yes'
                @errorarray << @submissionapplicationfield
                end
            end
            @applicationarray << @submissionapplicationfield

      end
    end




         if @errorarray.empty?
            @applicationarray.each do |arraymember|
              if arraymember.response.blank? ||
                arraymember.save
              end
            end
        end




      #@submissionapplication.field_name = node.text
      #@submissionapplication.response = params["response" + node.text]
      #@submissionapplication.save

      respond_to do |format|
        if 1==1
          format.js
        #flash[:notice] = "Thanks for adding a new client!"
         # format.html { redirect_to('/welcome', :notice=> 'client was successfully created.') }

          #format.json { render json: @submissionapplication, status: :created, location: @submissionapplication }
        else
           format.html { redirect_to(@submissionapplication)}
          format.html { render action: "new" }
          format.json { render json: @submissionapplication.errors, status: :unprocessable_entity }
        end
      end
  end


end
