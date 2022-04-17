class Documentpage < ActiveRecord::Base
  belongs_to :document
  belongs_to :generalagency
  belongs_to :agency

  begin
    Paperclip.interpolates :folder do |attachment, style|
      if !attachment.instance.generalagency_id.nil?
        attachment.instance.generalagency.docfolder
      else
        attachment.instance.agency.docfolder
      end


    end
  end
  attr_accessible :image, :page_number
  has_attached_file :image,
                    :whiny => false,
                    :storage => :s3,
                    :s3_protocol => 'https',
                    :s3_credentials => "#{Rails.root.to_s}/config/amazon_s3.yml",
                    :s3_permissions => :private,
                    :styles => { :thumb => ["107x138#", :png], :preview=>["340x440#", :png] } ,
                    :default_style => :original,
                    :local_root => "#{Rails.root}/tmp/",
                    :path => "GIC/pages/:id/:style.:extension"

  QUALITY  = 100
  DENSITY = '100X100'



  def authenticated_url(style = nil, expires_in = 10.minutes)
    image.s3_object(style).url_for(:read, :secure => true, :expires => expires_in).to_s
  end




end
