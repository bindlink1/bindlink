xml.instruct!

xml.tag!("Bindlink", "xmlns:xsi".to_sym => "http://www.w3.org/2001/XMLSchema-instance", "xmlns:xsd".to_sym => "http://www.w3.org/2001/XMLSchema") do


  xml.tag!("Policy") do
    xml.tag!("PolNum", "#{begin @policy.policy_number rescue 'N/A' end }")
    xml.tag!("EffectiveDate", "#{begin @policy.effective_date  rescue 'N/A' end }")
    xml.tag!("ExpirationDate", "#{begin @policy.expiration_date  rescue 'N/A' end }")
    xml.tag!("Status", "#{begin @policy.status  rescue 'N/A' end }")
    xml.tag!("CurrentPremium", "#{begin @policy.annualpremiumbase  rescue 'N/A' end }")
    xml.tag!("InsuredName", "#{begin @policy.namedinsured.named_insured  rescue 'N/A' end }")
    xml.tag!("InsuredAddress1", "#{begin @policy.namedinsured.address_1  rescue 'N/A' end }")
    xml.tag!("InsuredAddress2", "#{begin @policy.namedinsured.address_2  rescue 'N/A' end }")
    xml.tag!("InsuredCity", "#{begin @policy.namedinsured.city  rescue 'N/A' end }")
    xml.tag!("InsuredState", "#{begin @policy.namedinsured.state  rescue 'N/A' end }")
    xml.tag!("InsuredZip", "#{begin @policy.namedinsured.zip  rescue 'N/A' end }")
    xml.tag!("AgencyCode", "#{begin @policy.producingagency.agency_code  rescue 'N/A' end }")
    xml.tag!("AgencyName", "#{begin @policy.producingagency.agency_name  rescue 'N/A' end }")
    xml.tag!("AgencyAddress1", "#{begin @policy.producingagency.address_1  rescue 'N/A' end }")
    xml.tag!("AgencyAddress2", "#{begin @policy.producingagency.address_2  rescue 'N/A' end }")
    xml.tag!("AgencyCity", "#{begin @policy.producingagency.city  rescue 'N/A' end }")
    xml.tag!("AgencyState", "#{begin @policy.producingagency.state  rescue 'N/A' end }")
    xml.tag!("AgencyZip", "#{begin @policy.producingagency.zip  rescue 'N/A' end }")
    xml.tag!("CarrierName", "#{begin @policy.carrier.carrier_name  rescue 'N/A' end }")

  end




end



