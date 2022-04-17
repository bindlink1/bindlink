class Inboundemail < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  has_many :documents
  belongs_to :policy
  belongs_to :client
  belongs_to :submission
  belongs_to :agency
  belongs_to :general_agency

  attr_accessible :subject

  def emailcount(agencyid, agencytype)
    if agencytype == "Retail"
    @count = Inboundemail.where("agency_id=? AND assigned_flag is null AND read_flag is null", agencyid).count()
    else
      @count = Inboundemail.where("generalagency_id=? AND assigned_flag is null AND read_flag is null", agencyid).count()

    end
  end


  def associateattachmentspol(email_id, pol_id)
    @inboundemail = Inboundemail.find(email_id)
    @inboundemail.policy_id = pol_id
    @inboundemail.assigned_flag = 1
    @inboundemail.documents.each do |document|
      document.policy_id = pol_id
      document.save
    end
    @inboundemail.save

  end

  def associateattachmentsclient(email_id, client_id)
    @inboundemail = Inboundemail.find(email_id)
    @inboundemail.client_id = client_id
    @inboundemail.assigned_flag = 1
    @inboundemail.documents.each do |document|
      document.client_id = client_id
      document.save
    end
     @inboundemail.save

  end

  def associateattachmentssubmission(email_id, submission_id)
    @inboundemail = Inboundemail.find(email_id)
    @inboundemail.submission_id = submission_id
    @inboundemail.assigned_flag = 1
    @inboundemail.documents.each do |document|
      document.submission_id = submission_id
      document.save
    end
     @inboundemail.save
  end

  def processmessage(params)

 # process various message parameters:

      sender = params["sender"]
      from  = params["from"]
      subject = params["subject"]



        stripped_text= truncate(params["stripped-text"], :length=>6000, :omission=>'')





      self.sender = sender
      self.from = from
      self.subject = subject
      self.stripped_text = stripped_text
      self.attachment_count =  params['attachment-count'].to_i
      self.save






    end

end
