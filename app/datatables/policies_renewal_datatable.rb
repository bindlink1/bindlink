class PoliciesRenewalDatatable

  delegate :params, :h, :link_to,:number_to_currency,  to: :@view

  def initialize( view, i, type )
    @view = view
    @i = i
    @type = type
  end


  def as_json(options = {})
    policytotal = Policy.policyrenewalbyperiodcount(@i.to_i, @type)

    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: policytotal,
        iTotalDisplayRecords: policies.total_count,
        aaData: data
    }
  end

  private

  def data
    policies.map do |policy|
      [
          begin h(policy.namedinsured.named_insured) rescue "error" end,
          begin link_to(policy.policy_number, policy) rescue begin link_to("error", policy) rescue "error" end end,
          h(policy.expiration_date.strftime("%m/%d/%Y")),
          h(policy.carrier.carrier_name ),
          h(policy.lineofbusiness.line_name),
          h(policy.status),
          begin number_to_currency(policy.annualpremium,  :negative_format => "(%u%n)")rescue number_to_currency(0) end
      ]
    end
  end


  def policies
    @policies ||= fetch_policies
  end


  def fetch_policies
    policies = Policy.policyrenewalbyperiod(@i.to_i, @type)
    
    if sort_column == "policy_number" or sort_column == "expiration_date"
      policies = policies.order( sort_column + " " + sort_direction )
    else
      policies = policies.joins("LEFT JOIN namedinsureds ON policies.namedinsured_id = namedinsureds.id").order( 'namedinsureds.named_insured ' + sort_direction )
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
    columns = %w[named_insured policy_number expiration_date carrier line_name status annualpremium]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end