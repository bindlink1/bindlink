class InboundemailsController < ApplicationController
  layout 'applicationfunctional'

  skip_before_filter :postemail, :verify_authenticity_token

  before_filter :login_marshall, :only => ["show", "edit","update","destroy", "associateemail"]
  before_filter :only => ["show", "edit","update","destroy", "associateemail"] do |bf|
    inboundemail = Inboundemail.find(params[:id])
    if current_agent.isgeneralagent =="GA"
      bf.permission_marshall(inboundemail.generalagency_id)
    else
      bf.permission_marshall(inboundemail.agency_id)
    end


  end




  def index
    @inboundemails = Inboundemail.find_all_by_agency_id(233)
  end

  def show
    @inboundemail = Inboundemail.find(params[:id])
    @inboundemail.read_flag = 1
    @inboundemail.save

  end

  def edit
    @inboundemail = Inboundemail.find(params[:id])
  end

  def update
    @inboundemail = Inboundemail.find(params[:id])

    respond_to do |format|
      if @inboundemail.update_attributes(params[:inboundemail])
        format.html { redirect_to @inboundemail, notice: 'Successfully updated.' }

      end

    end
  end

  def associateemail
    @inboundemail = Inboundemail.find(params[:id])
  end

  def associatepolicy
    Inboundemail.new.associateattachmentspol(params[:email_id], params[:pol_id])
    @policy = Policy.find(params[:pol_id])
  end
  def associateclient
    Inboundemail.new.associateattachmentsclient(params[:email_id], params[:client_id])
    @client = Client.find(params[:client_id])
  end
  def associatesubmission

  end

  def destroy
    @inboundemail = Inboundemail.find(params[:id])
    @inboundemail.destroy

    respond_to do |format|
      format.html { redirect_to '/welcome' }
      format.json { head :ok }
    end

  end

  def postemail
    ##need to render this 'ok' else mailgun will think there is an error and keep delivering
    render :text => 'ok'
    ##is this post coming from a trusted source
    if params[:key] == 'j5uSS5sG'


      ## 1. Determine if this is a policy or a submission
      ## 2. Create a variable that stores policy/submission
      spaceindex = params["subject"].index(":")

      if spaceindex.nil?
        polnum = params["subject"]
      else
        spaceindex = spaceindex.to_i - 1
        polnum = params["subject"][0..spaceindex.to_i]
      end


      begin


        if Policy.where("policy_number=?",polnum.strip).count >0
          posttype = "policy"
        elsif  Submission.where("id=?",polnum.strip.to_i).count >0
          posttype = "submisison"
        else
          posttype = "notfound"
        end

      rescue
        posttype = "notfound"
      end


      ## 3. Use that variable in the exisiting document storage code as a switch



      if posttype != "notfound"

        if posttype == "policy"
          @policy_id = Policy.where("policy_number=?",polnum.strip).order("id desc")
        elsif posttype == "submisison"

          submission_id = params["subject"].strip.to_i
        end

        ## get the id for the agency from the parameters included in the post
        agency_id = params["id"]

        ## create a new inbound email
        @inboundemail = Inboundemail.new

        ## properly assign the agency id based on the type of agency indicated in the post
        if params[:type] == "Retail"
          @inboundemail.agency_id = agency_id
        else
          @inboundemail.generalagency_id = agency_id
        end

        ## set the inbound email attributes
        if posttype == "policy"
          @inboundemail.policy_id = @policy_id[0].id
        elsif posttype == "submisison"
          @inboundemail.submission_id = params["subject"].strip
        end

        @inboundemail.subject = params["subject"].strip
        @inboundemail.from = params["from"].strip
        @inboundemail.attachment_count =  params['attachment-count'].to_i
        @inboundemail.save

        attachment = " "

        count = params['attachment-count'].to_i
        emailhtml = "From: #{@inboundemail.from}<br>"
        emailhtml += "To: &#160; #{params["To"].strip}<br>" unless params["To"].nil?
        emailhtml += "to: &#160; #{params["to"].strip}<br>" unless params["to"].nil?
        emailhtml += "CC: &#160; #{params["CC"].strip}<br>" unless params["CC"].nil?
        emailhtml += "cc: &#160; #{params["cc"].strip}<br>" unless params["cc"].nil?
        emailhtml += "Subject: #{@inboundemail.subject}<br>"
        emailhtml += "Received: #{Time.now.in_time_zone("America/New_York").strftime("%b %d, %Y %l:%M %p (%Z)").gsub( "  ", " " )}<br><br>"
        emailhtml += params["body-html"]

        ## process all attachments:

        count.times do |i|
          stream = params["attachment-#{i+1}"]
          filename = stream.original_filename
          atta = 0
            begin
              attachmentdata = JSON.parse(params["content-id-map"])

              attachmentdata.each do |key, value|

                attachmentfilename = key.gsub("<", "")
                attachmentfilename = attachmentfilename.gsub(">", "")

                if attachmentfilename.index(filename).nil?

                else
                  atta = atta + 1

                end


              end
            rescue

            end

          stream = params["attachment-#{i+1}"]
          filename = stream.original_filename
          if atta == 0

            #data = stream.read()
            @document = Document.new()
            @document.image = params["attachment-#{i+1}"]
            @document.image_file_name = filename
            @document.name = filename
            @document.inboundemail_id = @inboundemail.id



            if posttype == "policy"
              @document.policy_id = @policy_id[0].id
            elsif posttype == "submisison"
              @document.submission_id = params["subject"].strip
            end

            if params[:type] == "Retail"
              @document.agency_id = agency_id
            else
              @document.generalagency_id = agency_id
            end
            @document.save
          else
            @document = Document.new()
            @document.image = params["attachment-#{i+1}"]
            @document.image_file_name = filename
            @document.name = filename
            @document.inboundemail_id = @inboundemail.id
            if params[:type] == "Retail"
              @document.agency_id = agency_id
            else
              @document.generalagency_id = agency_id
            end
            @document.save


            htmlattachmentlocation = emailhtml.index(filename)
            oldlink = emailhtml[(htmlattachmentlocation - 4)..(htmlattachmentlocation + filename.length + 17)]
            #download_document_path(@document)
            emailhtml =  emailhtml.gsub(oldlink, @document.image.expiring_url(10))

          end
        end


        ## Create a PDF out of the HTML of the Message


        count.times do |i|
          stream = params["attachment-#{i+1}"]
          filename = stream.original_filename
          attachment = attachment + " " + filename

        end

        link_sanitizer = Rails::Html::LinkSanitizer.new
        emailmessage = link_sanitizer.sanitize(params["body-html"])

        scrubber = Rails::Html::TargetScrubber.new
        scrubber.tags = ['script']

        begin
          emailhtml = PDFKit.new("Message forwarded to Bindlink. Email has the following attachments: " + attachment + "<br>" + emailhtml)

        rescue
          emailhtml = PDFKit.new("Message forwarded to Bindlink. Please check this email text for errors.")
        end

        file = StringIO.new(emailhtml.to_pdf) #mimic a real upload file
        file.class.class_eval { attr_accessor :original_filename, :content_type } #add attr's that paperclip needs
        file.original_filename = "your_report.pdf"
        file.content_type = "application/pdf"



        @document = Document.new()
        @document.image = file
        @document.image_file_name = "email" + params["subject"].strip
        @document.name = "E-mail Message From:" + params["from"].strip
        @document.inboundemail_id =  @inboundemail.id



        if posttype == "policy"
          @document.policy_id = @policy_id[0].id
        elsif posttype == "submisison"
          @document.submission_id = params["subject"].strip
        end


        if params[:type] == "Retail"
          @document.agency_id = agency_id
        else
          @document.generalagency_id = agency_id
        end
        @document.save


        ## SEND confirmation mail
        require 'rest-client'

        RestClient.post "https://api:key-6d69a04dfbd9cab62d59480d2312e112@api.mailgun.net/v2/mg.bindlink.com/messages",
        :from => "documentgnome@mg.bindlink.com",
        :to => params[:from],
        :subject => "#{params["subject"].strip}: Document successfully uploaded",
        :text => "Do not reply, this email is not monitored."


      else
        ## Send email letting user know that the policy was not found
        require 'rest-client'

        RestClient.post "https://api:key-6d69a04dfbd9cab62d59480d2312e112@api.mailgun.net/v2/mg.bindlink.com/messages",
        :from => "documentgnome@mg.bindlink.com",
        :to => params[:from],
        :subject => "Policy " + params["subject"].strip + " not found. Please try again.",
        :text => "Do not reply, this email is not monitored."

      end


    end



  end

end
