class AgedInvoicesDatatable

  delegate :params, :h, :link_to,:number_to_currency,  to: :@view

  def initialize( view, i )
    @view = view
    @i = i
  end


  def as_json(options = {})
    total = Invoice.agedinvoicecount(@i.to_i)

    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: total,
        iTotalDisplayRecords: invoices.total_count,
        aaData: data
    }
  end

  private

  def data
    invoices.map do |inv|
      [
          begin h(inv.policypremiumtransaction.policy.producingagency.agency_name) rescue "error" end,
          begin link_to(inv.policypremiumtransaction.policy.policy_number, inv.policypremiumtransaction.policy) rescue begin link_to("error", inv.policypremiumtransaction.policy) rescue "error" end end,
          h(inv.due_on.strftime("%m/%d/%Y")),
          h(inv.policypremiumtransaction.policy.carrier.carrier_name ),
          begin number_to_currency(inv.outstandingbalance,  :negative_format => "(%u%n)")rescue number_to_currency(0) end,
          h("Not Paid"),
          h((Date.today - inv.due_on).to_i),
      ]
    end
  end


  def invoices
    @invoices ||= fetch_invoices
  end


  def fetch_invoices
    invoices = Invoice.agedinvoice(@i.to_i)
    
    if sort_column == "due_on"
      invoices = invoices.order( sort_column + " " + sort_direction )
    elsif sort_column == "policy_number"
      invoices = invoices.joins(:policypremiumtransaction).
                          joins("JOIN policies ON policypremiumtransactions.policy_id = policies.id").
                          order( 'policies.policy_number ' + sort_direction )
    else
      invoices = invoices.joins(:policypremiumtransaction).
                          joins("JOIN policies ON policypremiumtransactions.policy_id = policies.id").
                          joins("JOIN producingagencies ON policies.producingagency_id = producingagencies.id").
                          order( 'producingagencies.agency_name ' + sort_direction )
    end
    #puts invoices.to_sql
    invoices = Kaminari.paginate_array(invoices).page(page).per(per_page)

    invoices
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[producer policy_number due_on carrier balance status days]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end