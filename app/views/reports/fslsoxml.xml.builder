xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.tag!("BatchDataSet", "xmlns:xsi".to_sym => "http://www.w3.org/2001/xml_schema_instance", "SubmissionType" => "AgentSS", "ReportingState" => "FL", "SchemaVersion" => "2.0") do
  xml.tag!("Brokerage") do
    xml.tag!("LicenseNumber", "l060903")
    xml.tag!("Name", "gic underwriters inc")
    xml.tag!("Contacts") do
      xml.tag!("Contact", "ContactType" => "SubmissionContact") do
        xml.tag!("FirstName", "juan_carlos")
        xml.tag!("LastName", "diaz_padron")
        xml.tag!("EmailAddress", "fslso@gicunderwriters.com")
        xml.tag!("ContactAddress") do
          xml.tag!("Address", "4075 sw 83rd ave")
          xml.tag!("City", "miami")
          xml.tag!("StateCode", "FL")
          xml.tag!("PostalCode", "33155")
          xml.tag!("CountryCode", "usa")
        end
        xml.tag!("PhoneNumber") do
          xml.tag!("AreaCode", "305")
          xml.tag!("Prefix", "554")
          xml.tag!("Line", "0353")
        end
      end
      xml.tag!("Contact" , "ContactType" => "BillingContact") do
        xml.tag!("FirstName", "Juan-Carlos")
        xml.tag!("LastName", "Diaz-Padron")
        xml.tag!("EmailAddress", "fslso@gicunderwriters.com")
        xml.tag!("ContactAddress") do
          xml.tag!("Address", "4075 sw 83rd ave")
          xml.tag!("City", "miami")
          xml.tag!("StateCode", "FL")
          xml.tag!("PostalCode", "33155")
          xml.tag!("CountryCode", "usa")
        end
        xml.tag!("PhoneNumber") do
          xml.tag!("AreaCode", "305")
          xml.tag!("Prefix", "554")
          xml.tag!("Line", "0353")
        end
      end
    end
  end
  xml.tag!("BrokerPolicies") do
    xml.tag!("BrokerPolicy") do
      xml.tag!("Broker") do
        xml.tag!("LicenseNumber", "p191117")
        xml.tag!("BrokerInfo") do
          xml.tag!("FirstName", "juan_carlos")
          xml.tag!("LastName", "diaz_padron")
          xml.tag!("EmailAddress", "fslso@gicunderwriters.com")
          xml.tag!("BrokerAddress") do
            xml.tag!("Address", "4075 sw 83rd ave")
            xml.tag!("City", "miami")
            xml.tag!("StateCode", "FL")
            xml.tag!("PostalCode", "33155")
            xml.tag!("CountryCode", "usa")
          end
          xml.tag!("MailingAddress") do
            xml.tag!("Address", "4075 sw 83rd ave")
            xml.tag!("City", "Miami")
            xml.tag!("StateCode", "FL")
            xml.tag!("PostalCode", "33155")
            xml.tag!("CountryCode", "USA")
          end
          xml.tag!("PhoneNumber") do
            xml.tag!("AreaCode", "305")
            xml.tag!("Prefix", "554")
            xml.tag!("Line", "0353")
          end
        end
      end
      ppti = 1
      xml.tag!("Policies") do
        @pollist.each_with_index do | p, pi |
          pptlist = Policypremiumtransaction.new.surpluslinespolicytransaction( @startdate, @enddate, p )
          if pptlist.count > 0
            xml.tag!("Policy" , "Xml_PolicyID" => "#{pi+1}") do
              xml.tag!("PolicyNumber", p.policy_number )
              xml.tag!("ExpirationDate", p.expiration_date.strftime("%Y-%m-%d") )
              xml.tag!("InsuredName", p.namedinsured.named_insured )
              xml.tag!("County", p.namedinsured.county )
              xml.tag!("PostalCode", p.namedinsured.fixzip )
              xml.tag!("Transactions") do
                pptlist.each do | ppt |
                  xml.tag!("Transaction" , "Xml_TransactionID" => "#{ppti}") do
                    xml.tag!("CoverageCode", p.lineofbusiness.coverage_code )
                    xml.tag!("TaxStatus", "0")
                    xml.tag!("TransactionType", ppt.surpluslinestransactiontype )
                    xml.tag!("EffectiveDate", ppt.transactioneffective.strftime("%Y-%m-%d") )
                    xml.tag!("Insurer" , "Xml_InsurerID" => "#{ppti}") do
                      xml.tag!("Name", p.carrier.carrier_name )
                      xml.tag!("NAICNumber", p.carrier.naic_number )
                    end
                    xml.tag!("Premium", ppt.base_premium.round(2) )
                    xml.tag!("PolicyFee", ppt.revenuefees.round(2) )
                  end
                  ppti = ppti + 1
                end
              end
            end
          end
        end
      end
    end
  end
end