class Document < ActiveRecord::Base
  has_many :documentpages, :dependent => :destroy

  Paperclip.interpolates :folder do |attachment, style|
    if !attachment.instance.generalagency_id.nil?
      attachment.instance.generalagency.docfolder
    else
      attachment.instance.agency.docfolder
    end
  end


  has_attached_file :image,
                    :whiny => false,
                    :storage => :s3,
                    :s3_protocol => 'https',
                    :s3_credentials => "#{Rails.root.to_s}/config/amazon_s3.yml",
                    :s3_permissions => :private,
                    :styles => { :thumb => ["107x138#", :png], :preview=>["340x440#", :png] } ,
                    :default_style => :original,
                    :local_root => "#{Rails.root}/tmp/",
                    :path => ":folder/:id/:style.:extension"
                    :resume_attachment
  before_post_process :image?

  def image?
    (image_content_type =~ SUPPORTED_IMAGES_REGEX).present?
  end

  SUPPORTED_IMAGE_FORMATS = ["image/jpeg", "image/png", "image/gif", "image/bmp", "application/pdf", "image/tif"]
  SUPPORTED_IMAGES_REGEX = Regexp.new('\A(' + SUPPORTED_IMAGE_FORMATS.join('|') + ')\Z')


  def authenticated_url(style = nil, expires_in = 1.minutes)
    image.s3_object(style).url_for(:read, :secure => true, :expires => expires_in).to_s
  end


  belongs_to :client
  belongs_to :policy
  belongs_to :quote
  belongs_to :submission
  belongs_to :inboundemail
  belongs_to :generalagency
  belongs_to :agency
  belongs_to :producingagency

  attr_accessible :image, :name, :documentpages


  def make_pages
    if updated_at_changed?
      Delayed::Job.enqueue Createdocumentpages.new(self.id)
    end
  end


  def movedocstopolicy(polid)
    tempdoc = Document.new
    tempdoc = self

    tempdoc.policy_id = polid
    tempdoc.quote_id = nil

    tempdoc.save
  end


  def pagecount
    Documentpage.find_all_by_document_id(self.id).count
  end


  def policydoccount(polid)
    dcount = Document.where( "policy_id = ? AND doctype IS NULL", polid ).count
  end


  def policyendorsecount(polid)
    dcount = Document.where( "policy_id = ? AND doctype = 'Endorsements'", polid ).count
  end


  def policyclaimcount(polid)
    dcount = Document.where( "policy_id = ? AND doctype = 'Claims'", polid ).count
  end


  def clientdoccount(clientid)
    dcount = Document.find_all_by_client_id(clientid).count
  end


  def producerdoccount(producerid)
    dcount = Document.find_all_by_producingagency_id(producerid).count
  end
end
