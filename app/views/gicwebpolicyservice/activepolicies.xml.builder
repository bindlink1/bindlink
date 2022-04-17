xml.instruct!
xml.activepolicies do
  unless @producingagency.nil?
    @producingagency.activepoliciesregardlessofeffectivedate.each do |policy|
      xml.policy do
        xml.policy_number policy.policy_number
        xml.effective_date policy.effective_date.strftime("%m-%d-%Y")
        xml.expiration_date policy.expiration_date.strftime("%m-%d-%Y")
        xml.named_insured policy.namedinsured.named_insured
        xml.premium policy.policypremiumsum
        xml.carrier policy.carrier.carrier_name
        xml.lineofbusiness policy.lineofbusiness.line_name
        xml.documents do
          policy.documents.where("created_at > '2018-04-16'").order("created_at desc").each do |document|
            if document.name.start_with?( 'Cancellation', 'Final Audit', 'New Business', 'Reinstatement', 'Renewal Offer', 'Non-Renewal', 'Endorsement –' ) then
              xml.documentid document.id
              xml.documentname document.name
              xml.documenturl document.authenticated_url
              xml.createddate document.created_at.strftime("%m-%d-%Y")
            end
          end
        end
      end
    end
  end
end
