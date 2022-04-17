xml.instruct!

xml.tag!("ACORD", "xmlns:xsi".to_sym => "http://www.w3.org/2001/XMLSchema-instance", "xmlns:xsd".to_sym => "http://www.w3.org/2001/XMLSchema") do

  xml.tag!("SignonRq") do
    xml.tag!("SignonPswd") do
      xml.tag!("CustId") do
        xml.tag!("CustLoginId","")
        xml.tag!("SPName","com.bindlink")
      end
      xml.tag!("CustPswd") do
        xml.tag!("Pswd", "PASSWORD")
        xml.tag!("EncryptionTypeCd", "NONE")
      end
    end
    xml.tag!("ClientDt", "#{Date.today}")
    xml.tag!("CustLangPref", "English")

    xml.tag!("ClientApp") do
      xml.tag!("Org", "Bindlink")
      xml.tag!("Name", "LightningRater")
      xml.tag!("Version", "1.1")
    end
  end

  xml.tag!("InsuranceSvcRq") do
    xml.tag!("RqUID")
    xml.tag!("com.webcetera__ApplicantID")
    xml.tag!("PersAutoPolicyQuoteInqRq") do
      xml.tag!("RqUID")
      xml.tag!("TransactionRequestDt")
      xml.tag!("CurCd", "USAD")
      xml.tag!("Producer") do
        xml.tag!("ItemIdInfo") do
          xml.tag!("AgencyId", "#{begin @policy.acord_xml_pers_auto_policy.acord_xml_producer.agency_id rescue 000 end}")
        end
=begin
        xml.tag!("GeneralPartyInfo") do
          xml.tag!("NameInfo") do
            xml.tag!("PersonName") do
              xml.tag!("Surname", "#{@policy.acord_xml_pers_auto_policy.acord_xml_producer.acord_xml_general_party_info.surname}")
              xml.tag!("GivenName", "#{@policy.acord_xml_pers_auto_policy.acord_xml_producer.acord_xml_general_party_info.given_name}")

            end
            xml.tag!("TaxIdentity") do
              xml.tag!("TaxIdTypeCd", "#{@policy.acord_xml_pers_auto_policy.acord_xml_producer.acord_xml_general_party_info.tax_id_type_cd}")
              xml.tag!("TaxId", "#{@policy.acord_xml_pers_auto_policy.acord_xml_producer.acord_xml_general_party_info.tax_id}")
            end
          end
          xml.tag!("Addr") do
            xml.tag!("AddrTypeCd", "#{@policy.acord_xml_pers_auto_policy.acord_xml_producer.acord_xml_general_party_info.addr_type_cd}")
            xml.tag!("Addr1", "#{@policy.acord_xml_pers_auto_policy.acord_xml_producer.acord_xml_general_party_info.addr_1}")
            xml.tag!("Addr2", "#{@policy.acord_xml_pers_auto_policy.acord_xml_producer.acord_xml_general_party_info.addr_2}")
            xml.tag!("City", "#{@policy.acord_xml_pers_auto_policy.acord_xml_producer.acord_xml_general_party_info.city}")
            xml.tag!("County", "#{@policy.acord_xml_pers_auto_policy.acord_xml_producer.acord_xml_general_party_info.county}")
            xml.tag!("StateProvCd", "#{@policy.acord_xml_pers_auto_policy.acord_xml_producer.acord_xml_general_party_info.state_prov_cd}")
            xml.tag!("PostalCode", "#{@policy.acord_xml_pers_auto_policy.acord_xml_producer.acord_xml_general_party_info.postal_code}")
          end
          xml.tag!("Communications") do
            xml.tag!("PhoneInfo") do
              xml.tag!("PhoneTypeCd", "#{@policy.acord_xml_pers_auto_policy.acord_xml_producer.acord_xml_general_party_info.phone_type_cd}")
              xml.tag!("CommunicationUseCd", "#{@policy.acord_xml_pers_auto_policy.acord_xml_producer.acord_xml_general_party_info.communication_use_cd}")
              xml.tag!("PhoneNumber", "#{@policy.acord_xml_pers_auto_policy.acord_xml_producer.acord_xml_general_party_info.phone_number}")
              xml.tag!("Extension", "")
            end

          end
        end
=end
        xml.tag!("ProducerInfo") do
          xml.tag!("ContractNumber", "1234567")
          xml.tag!("PlacingOffice", "")
        end
      end

      @policy.acord_xml_pers_auto_policy.acord_xml_insured_or_principals.each do |insuredorprincipal|
        xml.tag!("InsuredOrPrincipal") do
          xml.tag!("GeneralPartyInfo") do
            xml.tag!("NameInfo") do
              xml.tag!("PersonName") do
                xml.tag!("Surname", "#{insuredorprincipal.acord_xml_general_party_info.surname}")
                xml.tag!("GivenName", "#{insuredorprincipal.acord_xml_general_party_info.given_name}")

              end
              xml.tag!("TaxIdentity") do
                xml.tag!("TaxIdTypeCd", "#{insuredorprincipal.acord_xml_general_party_info.tax_id_type_cd}")
                xml.tag!("TaxId", "#{insuredorprincipal.acord_xml_general_party_info.tax_id}")
              end
            end
            xml.tag!("Addr") do
              xml.tag!("AddrTypeCd", "#{insuredorprincipal.acord_xml_general_party_info.addr_type_cd}")
              xml.tag!("Addr1", "#{insuredorprincipal.acord_xml_general_party_info.addr_1}")
              xml.tag!("Addr2", "#{insuredorprincipal.acord_xml_general_party_info.addr_2}")
              xml.tag!("City", "#{insuredorprincipal.acord_xml_general_party_info.city}")
              xml.tag!("County", "#{insuredorprincipal.acord_xml_general_party_info.county}")
              xml.tag!("StateProvCd", "#{insuredorprincipal.acord_xml_general_party_info.state_prov_cd}")
              xml.tag!("PostalCode", "#{insuredorprincipal.acord_xml_general_party_info.postal_code}")
            end
            xml.tag!("Communications") do
              xml.tag!("PhoneInfo") do
                xml.tag!("PhoneTypeCd", "#{insuredorprincipal.acord_xml_general_party_info.phone_type_cd}")
                xml.tag!("CommunicationUseCd", "#{insuredorprincipal.acord_xml_general_party_info.communication_use_cd}")
                xml.tag!("PhoneNumber", "#{insuredorprincipal.acord_xml_general_party_info.phone_number}")
                xml.tag!("Extension", "")
              end

            end
          end
          xml.tag!("InsuredOrPrincipalInfo") do
            xml.tag!("InsuredOrPrincipalRoleCd", "#{insuredorprincipal.insured_or_principal_role_cd}")

          end
        end
      end

      xml.tag!("PersPolicy") do
        xml.tag!("LOBCd", "#{begin @policy.acord_xml_pers_auto_policy.acord_xml_pers_policy.lob_cd rescue 'N/A' end }")
        xml.tag!("BillingMethodCd", "#{begin @policy.acord_xml_pers_auto_policy.acord_xml_pers_policy.billing_method_cd rescue 'N/A' end }")
        xml.tag!("OtherOrPriorPolicy") do

        end
        xml.tag!("ContractTerm") do
          xml.tag!("DurationPeriod") do
            xml.tag!("NumUnits", "6")
            xml.tag!("UnitMeasurementCd", "Months")
          end
        end
        xml.tag!("EffectiveDt", "#{begin @policy.acord_xml_pers_auto_policy.acord_xml_pers_policy.effective_dt rescue 'N/A' end}")
        xml.tag!("PersApplicationInfo") do
          xml.tag!("ResidenceTypeCd", "#{begin @policy.acord_xml_pers_auto_policy.acord_xml_pers_policy.residence_type_cd rescue 'N/A' end }")
          xml.tag!("LengthTimeCurrentAddr") do
            xml.tag!("DurationPeriod") do
              xml.tag!("NumUnits", "#{begin @policy.acord_xml_pers_auto_policy.acord_xml_pers_policy.length_years rescue 'N/A' end}")
              xml.tag!("UnitMeasurementCd", "Years")
            end
            xml.tag!("DurationPeriod") do
              xml.tag!("NumUnits", "#{begin @policy.acord_xml_pers_auto_policy.acord_xml_pers_policy.length_months rescue 'N/A' end}")
              xml.tag!("UnitMeasurementCd", "Months")
            end
          end
        end

        begin
        @policy.acord_xml_pers_auto_policy.acord_xml_pers_policy.acord_xml_driver_vehs.each do |driverveh|
           xml.tag!("DriverVeh",  "VehRef" => "Veh1", "DriverRef" => "Drv1") do
             xml.tag!("UsePct", driverveh.use_pct)
           end
        end
        rescue
        end


      end

      xml.tag!("PersAutoLineBusiness") do
        @policy.acord_xml_pers_auto_policy.acord_xml_pers_auto_line_business.acord_xml_pers_drivers.each do |driver|
          xml.tag!("PersDriver",  "id" => "Drv#{driver.id}") do
            xml.tag!("GeneralPartyInfo") do
              xml.tag!("NameInfo") do
                xml.tag!("PersonName") do
                  xml.tag!("Surname", "#{driver.acord_xml_general_party_info.surname}")
                  xml.tag!("GivenName", "#{driver.acord_xml_general_party_info.given_name}")

                end
                xml.tag!("TaxIdentity") do
                  xml.tag!("TaxIdTypeCd", "#{driver.acord_xml_general_party_info.tax_id_type_cd}")
                  xml.tag!("TaxId", "#{driver.acord_xml_general_party_info.tax_id}")
                end
              end

            end
            xml.tag!("DriverInfo") do
              xml.tag!("PersonInfo") do
                xml.tag!("GenderCd", driver.gender_cd)
                xml.tag!("BirthDt", driver.birth_dt)
                xml.tag!("MaritalStatusCd", driver.marital_status_cd)
                xml.tag!("OccupationClassCd", driver.occupation_class_cd)
              end
              xml.tag!("License") do
                xml.tag!("LicenseStatusCd", driver.license_status_cd)
                xml.tag!("LicenseDt", driver.license_dt)
                xml.tag!("DriverLicenseNumber", driver.driver_license_number)
                xml.tag!("StateProvCd", driver.state_prov_cd)
              end
            end
            xml.tag!("PersDriverInfo",  "VehPrincipallyDrivenRef" => "Veh#{driver.id}") do
              xml.tag!("ResidentCustodyInd", driver.resident_custody_ind)
              xml.tag!("DriverType", driver.driver_type)
              xml.tag!("DriverRelationshipToApplicantCd", driver.driver_relationship_to_applicant_cd)
              xml.tag!("MatureDriverInd", driver.mature_driver_ind)
              xml.tag!("DriverTrainingInd", driver.driver_training_ind)
              xml.tag!("GoodStudentCd", driver.good_student_cd)
              xml.tag!("DistantStudentInd", driver.distant_student_ind)
              xml.tag!("FinancialResponsibilityFiling") do
                xml.tag!("FilingStatusCd", driver.filing_status_cd)
              end
              xml.tag!("LicenseSuspendedrevokedInd", driver.license_suspended_revoked_ind)
            end
          end
        end
        @policy.acord_xml_pers_auto_policy.acord_xml_pers_auto_line_business.acord_xml_pers_vehs.each do |vehicle|
          xml.tag!("PersVeh",  "id" => "Veh#{vehicle.id}",  "LocationRef" => "L0#{vehicle.id}") do
            xml.tag!("ModelYear", vehicle.model_year)
            xml.tag!("Manufacturer", vehicle.manufacturer)
            xml.tag!("Model", vehicle.model)
            xml.tag!("VehIdentificationNumber", vehicle.veh_identification_number)
            xml.tag!("AntiLockBrakeCd", vehicle.anti_lock_brake_cd)
            xml.tag!("AntiTheftDeviceCd", vehicle.anti_theft_device_cd)
            xml.tag!("DaytimeRunningLightInd", vehicle.daytime_running_light_ind)
            xml.tag!("PresentValueAmt", vehicle.present_value_amt)
            xml.tag!("CostNewAmt") do
              xml.tag!("Amt", vehicle.cost_new_amt)
            end
            xml.tag!("DistanceOneWay") do
              xml.tag!("NumUnits", vehicle.distance_one_way)
              xml.tag!("UnitMeasurementCd", "Miles")
            end
            xml.tag!("EstimatedAnnualDistance") do
              xml.tag!("NumUnits", vehicle.estimated_annual_distance)
              xml.tag!("UnitMeasurementCd", "Miles")
            end
            xml.tag!("Ownership", vehicle.ownership)
            xml.tag!("CarpoolInd", vehicle.carpool_ind)
            xml.tag!("NumDaysDrivenPerWeek", vehicle.num_days_driven_per_week)
            xml.tag!("LengthTimePerMonth", vehicle.length_time_per_month)
            xml.tag!("AirBackTypeCd", vehicle.air_bag_type_cd)
            xml.tag!("VehPerformanceCd", vehicle.veh_performance_cd)
            xml.tag!("VehUseCd", vehicle.veh_use_cd)
            xml.tag!("ExistingUnrepairedDamageInd", vehicle.existing_unrepaired_damage_ind)
            vehicle.acord_xml_coverages.each do |coverage|
              xml.tag!("Coverage") do
                xml.tag!("CoverageCd", coverage.coverage_cd)
                coverage.acord_xml_limits.each do |limit|
                  xml.tag!("Limit") do
                    xml.tag!("FormatInteger") do
                      xml.tag!("Amt", limit.limit_amt)
                    end
                    xml.tag!("LimitAppliesToCd", limit.limit_applies_to_cd)
                  end
                end
                coverage.acord_xml_deductibles.each do |deductible|
                  xml.tag!("Deductible") do
                    xml.tag!("FormatInteger") do
                      xml.tag!("Amt", deductible.deductible_amt)
                    end
                    xml.tag!("DeductibleTypeCd", deductible.deductible_type_cd)
                    xml.tag!("DeductibleAppliesToCd", deductible.deductible_applies_to_cd)
                  end
                end
                coverage.acord_xml_options.each do |option|
                  xml.tag!("Option") do
                    xml.tag!("OptionCd", option.option_cd)
                  end
                end
              end
            end
          end
        end


      end

      xml.tag!("Location",  "id" => "L01") do
        @policy.acord_xml_pers_auto_policy.acord_xml_locations.each do |location|
          xml.tag!("Addr") do
            xml.tag!("AddrTypeCd", location.addr_type_cd)
            xml.tag!("Addr1", location.addr_1)
            xml.tag!("City", location.city)
            xml.tag!("County", location.county)
            xml.tag!("StateProvCd", location.state_prov_cd)
            xml.tag!("PostalCode", location.postal_code)

          end
        end
      end
    end
  end
end

