
class PoliciesDatatable

  delegate :params, :h, :link_to,:number_to_currency,  to: :@view
  def initialize(view, agencyid, agencytype)

    @view = view
    @agencyid = agencyid
    @agencytype = agencytype

  end

  def as_json(options = {})
    if @agencytype == "Retail"
      policytotal = Policy.where("status='Active'").find_all_by_agency_id(@agencyid).count
    else

      policytotal = Policy.where("status='Active'").find_all_by_generalagency_id(@agencyid).count
    end

    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: policytotal,
        iTotalDisplayRecords: policies.total_count,
        aaData: data
    }
  end

  private

  def data
    if @agencytype == "Retail"




      policies.map do |policy|
        [
            link_to(policy.client.fullname, policy),
            h(policy.policy_number),
            h(policy.carrier.carrier_name ),
            h(policy.effective_date.strftime("%m/%d/%Y")),
            h(policy.lineofbusiness.line_name),
            begin number_to_currency(policy.policybalance,  :negative_format => "(%u%n)")rescue number_to_currency(0)  end,
            h(policy.status)
        ]
      end
    else
      policies.map do |policy|
        [
            begin link_to(policy.namedinsured.named_insured, policy) rescue "error" end,
            h(policy.policy_number),
            h(policy.carrier.carrier_name ),
            h(policy.effective_date.strftime("%m/%d/%Y")),
            h(policy.lineofbusiness.line_name),
            begin number_to_currency(policy.policybalance,  :negative_format => "(%u%n)")rescue number_to_currency(0) end,
            h(policy.status)
        ]
      end
    end

  end

  def policies
    @policies ||= fetch_policies
  end

  def fetch_policies

    sorting = sort_column+" "+ sort_direction

    if @agencytype == "Retail"
      if sort_column == "carrier"
        policies = Policy.where("status='Active'").joins(:carrier).order('carriers.carrier_name '+sort_direction).find_all_by_agency_id(@agencyid)
      elsif  sort_column == "line_name"
        policies = Policy.where("status='Active'").joins(:lineofbusiness).order('lineofbusinesses.line_name ' +sort_direction).find_all_by_agency_id(@agencyid)
      elsif sort_column == "fullname"
        policies = Policy.where("status='Active'").find_all_by_agency_id(@agencyid)
        if sort_direction == 'asc'
          policies.sort_by!(&:fullname)
        else
          policies.sort_by!(&:fullname).reverse!
        end

      elsif sort_column == "policybalance"

        policies = Policy.where("status='Active'").find_all_by_agency_id(@agencyid)

        if sort_direction == 'asc'
          policies.sort_by!(&:policybalance)
        else
          policies.sort_by!(&:policybalance).reverse!
        end


      else
        policies = Policy.where("status='Active'").order(sorting).find_all_by_agency_id(@agencyid)
      end
    else

      if sort_column == "carrier"
        policies = Policy.joins(:carrier).order('carriers.carrier_name '+sort_direction).find_all_by_generalagency_id(@agencyid)
      elsif  sort_column == "line_name"
        policies = Policy.joins(:lineofbusiness).order('lineofbusinesses.line_name ' +sort_direction).find_all_by_generalagency_id(@agencyid)
      elsif  sort_column == "named_insured"
        policies = Policy.joins(:namedinsured).order('namedinsureds.named_insured ' +sort_direction).find_all_by_generalagency_id(@agencyid)
      elsif sort_column == "policybalance"
        policies = Policy.find_all_by_generalagency_id(@agencyid)

        if sort_direction == 'asc'
          policies.sort_by!(&:policybalance)
        else
          policies.sort_by!(&:policybalance).reverse!
        end
      else
        policies = Policy.where("status='Active'").order(sorting).find_all_by_generalagency_id(@agencyid)
      end
    end

    policies = Kaminari.paginate_array(policies).page(page).per(per_page)

    policies
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    if @agencytype == "Retail"
      columns = %w[fullname policy_number carrier effective_date line_name policybalance status]
    else

      columns = %w[named_insured policy_number carrier effective_date line_name policybalance status]
    end

    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction

    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end