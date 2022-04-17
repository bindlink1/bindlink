class AcordXmlPersAutoPoliciesController < ApplicationController
  layout 'applicationfunctional'
  before_filter :login_marshall


  def new
    @axpap = AcordXmlPersAutoPolicy.new
    @policy = Policy.find(params[:policy_id])
    @axpap.acord_xml_locations.build
    @axpap.build_acord_xml_pers_auto_line_business  do |palb|
      palb.acord_xml_pers_vehs.build do |pv|
        pv.acord_xml_coverages.build do |c|
          c.acord_xml_limits.build
          c.acord_xml_deductibles.build
          c.acord_xml_options.build
        end

      end

    end

    @axpap.acord_xml_insured_or_principals.build  do  |iop|
      iop.build_acord_xml_general_party_info  do |gpi|
        gpi.build_acord_xml_pers_driver
      end

    end


  end


  def edit

    @axpap = AcordXmlPersAutoPolicy.find(params[:id])



  end

  def update
    @axpap = AcordXmlPersAutoPolicy.find(params[:id])


    #location existing
    params[:acord_xml_pers_auto_policy][:acord_xml_location].each do |key, value|

      location = AcordXmlLocation.find(key)
      location.update_attributes(params[:acord_xml_pers_auto_policy][:acord_xml_location][key.to_s])
    end

    #location new, if any
    begin
      params[:acord_xml_pers_auto_policy][:acord_xml_locations].each do |key, value|
        @axpap.acord_xml_locations.build(params[:acord_xml_pers_auto_policy][:acord_xml_locations][key.to_s])
      end
    rescue
    end


    #driver existing
    params[:acord_xml_pers_auto_policy][:acord_xml_insured_or_principal].each do |key, value|


      begin
        insured_or_principal = AcordXmlInsuredOrPrincipal.find(value[:id].to_i)


        insured_or_principal.update_attributes(params[:acord_xml_pers_auto_policy][:acord_xml_insured_or_principal][key.to_s]) do |iop|
          iop.acord_xml_general_party_info.update_attributes(params[:acord_xml_pers_auto_policy][:acord_xml_insured_or_principal][key.to_s][:acord_xml_general_party_info]["1"]) do |gpi|
            gpi.acord_xml_pers_driver.update_attributes(params[:acord_xml_pers_auto_policy][:acord_xml_insured_or_principal][key.to_s][:acord_xml_general_party_info]["1"][:acord_xml_pers_driver])
          end
        end
      rescue
      end
    end

    #driver new, if any

    begin
      params[:acord_xml_pers_auto_policy][:acord_xml_insured_or_principals].each do |key, value|
        @axpap.acord_xml_insured_or_principals.build(params[:acord_xml_pers_auto_policy][:acord_xml_insured_or_principals][key.to_s]) do |iop|
          iop.build_acord_xml_general_party_info(params[:acord_xml_pers_auto_policy][:acord_xml_insured_or_principals][key.to_s][:acord_xml_general_party_info]["1"])  do |gpi|
            gpi.build_acord_xml_pers_driver(params[:acord_xml_pers_auto_policy][:acord_xml_insured_or_principals][key.to_s][:acord_xml_general_party_info]["1"][:acord_xml_pers_drivers]) do |pd|

              pd.acord_xml_pers_auto_line_business = @axpap.acord_xml_pers_auto_line_business
            end

          end
        end
      end

    rescue
    end

    #vehicle edit

    params[:acord_xml_pers_auto_policy][:acord_xml_pers_auto_line_business_attributes][:acord_xml_pers_veh].each do |key, value|

      vehicle = AcordXmlPersVeh.find(key)


      vehicle.update_attributes(params[:acord_xml_pers_auto_policy][:acord_xml_pers_auto_line_business_attributes][:acord_xml_pers_veh][key.to_s]) do |pv|
        params[:acord_xml_pers_auto_policy][:acord_xml_pers_auto_line_business_attributes][:acord_xml_pers_vehs][key.to_s][:acord_xml_coverages].each do |ckey, value|
          #pv.acord_xml_coverages.build(params[:acord_xml_pers_auto_policy][:acord_xml_pers_auto_line_business_attributes][:acord_xml_pers_vehs][key.to_s][:acord_xml_coverages][ckey.to_s]) do |c|
           # c.acord_xml_limits.build(params[:acord_xml_pers_auto_policy][:acord_xml_pers_auto_line_business_attributes][:acord_xml_pers_vehs][key.to_s][:acord_xml_coverages][ckey.to_s][:acord_xml_limits])
            #c.acord_xml_deductibles.build(params[:acord_xml_pers_auto_policy][:acord_xml_pers_auto_line_business_attributes][:acord_xml_pers_vehs][key.to_s][:acord_xml_coverages][ckey.to_s][:acord_xml_deductibles])
          #end
        end
      end
    end





    #vehicle new, if any
    begin


      params[:acord_xml_pers_auto_policy][:acord_xml_pers_auto_line_business_attributes][:acord_xml_pers_vehs].each do |key, value|



        @palb = AcordXmlPersAutoLineBusiness.find(@axpap.acord_xml_pers_auto_line_business.id)
        @palb.acord_xml_pers_vehs.build(params[:acord_xml_pers_auto_policy][:acord_xml_pers_auto_line_business_attributes][:acord_xml_pers_vehs][key.to_s]) do |pv|
          params[:acord_xml_pers_auto_policy][:acord_xml_pers_auto_line_business_attributes][:acord_xml_pers_vehs][key.to_s][:acord_xml_coverages].each do |ckey, value|
            pv.acord_xml_coverages.build(params[:acord_xml_pers_auto_policy][:acord_xml_pers_auto_line_business_attributes][:acord_xml_pers_vehs][key.to_s][:acord_xml_coverages][ckey.to_s]) do |c|
              c.acord_xml_limits.build(params[:acord_xml_pers_auto_policy][:acord_xml_pers_auto_line_business_attributes][:acord_xml_pers_vehs][key.to_s][:acord_xml_coverages][ckey.to_s][:acord_xml_limits])
              c.acord_xml_deductibles.build(params[:acord_xml_pers_auto_policy][:acord_xml_pers_auto_line_business_attributes][:acord_xml_pers_vehs][key.to_s][:acord_xml_coverages][ckey.to_s][:acord_xml_deductibles])
            end
          end
        end
      end
      @palb.save
    rescue
    end


    @axpap.save



    redirect_to policy_path(:id=>@axpap.policy_id)


  end
  def create



    @axpap = AcordXmlPersAutoPolicy.new



    params[:acord_xml_pers_auto_policy][:acord_xml_locations].each do |key, value|
      @axpap.acord_xml_locations.build(params[:acord_xml_pers_auto_policy][:acord_xml_locations][key.to_s])
    end


    @axpap.build_acord_xml_pers_auto_line_business  do | palb|

      params[:acord_xml_pers_auto_policy][:acord_xml_pers_auto_line_business_attributes][:acord_xml_pers_vehs].each do |key, value|


        palb.acord_xml_pers_vehs.build(params[:acord_xml_pers_auto_policy][:acord_xml_pers_auto_line_business_attributes][:acord_xml_pers_vehs][key.to_s]) do |pv|
          params[:acord_xml_pers_auto_policy][:acord_xml_pers_auto_line_business_attributes][:acord_xml_pers_vehs][key.to_s][:acord_xml_coverages].each do |ckey, value|
            pv.acord_xml_coverages.build(params[:acord_xml_pers_auto_policy][:acord_xml_pers_auto_line_business_attributes][:acord_xml_pers_vehs][key.to_s][:acord_xml_coverages][ckey.to_s]) do |c|
              c.acord_xml_limits.build(params[:acord_xml_pers_auto_policy][:acord_xml_pers_auto_line_business_attributes][:acord_xml_pers_vehs][key.to_s][:acord_xml_coverages][ckey.to_s][:acord_xml_limits])
              c.acord_xml_deductibles.build(params[:acord_xml_pers_auto_policy][:acord_xml_pers_auto_line_business_attributes][:acord_xml_pers_vehs][key.to_s][:acord_xml_coverages][ckey.to_s][:acord_xml_deductibles])
            end
          end
        end
      end
    end

    params[:acord_xml_pers_auto_policy][:acord_xml_insured_or_principals].each do |key, value|
      @axpap.acord_xml_insured_or_principals.build(params[:acord_xml_pers_auto_policy][:acord_xml_insured_or_principals][key.to_s]) do |iop|
        iop.build_acord_xml_general_party_info(params[:acord_xml_pers_auto_policy][:acord_xml_insured_or_principals][key.to_s][:acord_xml_general_party_info]["1"])  do |gpi|
          gpi.build_acord_xml_pers_driver(params[:acord_xml_pers_auto_policy][:acord_xml_insured_or_principals][key.to_s][:acord_xml_general_party_info]["1"][:acord_xml_pers_drivers]) do |pd|

            pd.acord_xml_pers_auto_line_business = @axpap.acord_xml_pers_auto_line_business
          end

        end
      end
    end

    @axpap.policy_id = params[:policy_id]
    @axpap.save

    redirect_to policy_path(:id=>@axpap.policy_id)
  end

  def associatevehdrv
    @axpap = AcordXmlPersAutoPolicy.find(params[:id])
  end


  def show

  end

  def index

  end

end
