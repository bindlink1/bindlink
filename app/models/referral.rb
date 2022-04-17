class Referral < ActiveRecord::Base
  belongs_to :client
  belongs_to :agency
  belongs_to :referer
  belongs_to :client
  accepts_nested_attributes_for :referer


  def createnew(referralparams, agency_id)


    referral = Referral.new
    refcount = 0
    if !referralparams[:referral][:referer_attributes][:referer_name].blank?
      refcount =  refcount + 1
    end
    if !referralparams[:referral][:client_id].blank?
      refcount =  refcount + 1
    end
    if !referralparams[:referral][:referer_id].blank?
      refcount =  refcount + 1
    end

    if refcount == 1
      if !referralparams[:referral][:referer_attributes][:referer_name].blank?
        newreferer = Referer.new
        newreferer.referer_name  = referralparams[:referral][:referer_attributes][:referer_name]
        newreferer.agency_id = agency_id
        newreferer.save

        referral.referer_id = newreferer.id
      end
      if !referralparams[:referral][:client_id].blank?

        newreferer = Referer.new
        newreferer.client_id  = referralparams[:referral][:client_id]
        newreferer.agency_id = agency_id
        newreferer.save

        client = Client.find(referralparams[:referral][:client_id])
        client.referer_id = newreferer.id
        client.save

        referral.referer_id = newreferer.id
      end
      if !referralparams[:referral][:referer_id].blank?
        referral.referer_id = referralparams[:referral][:referer_id]
      end
      referral.agency_id =  agency_id
      referral.client_id = referralparams[:client_id]
    end



    if refcount > 1 then
      return "Please select either a client or referrer, not both."
    elsif refcount == 0
      return "Please select either a client or referrer."
    elsif

    referral.save
      return "OK"
    end


  end

end
