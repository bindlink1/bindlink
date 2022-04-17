
class ProducingagenciesDatatable


  delegate :params, :h, :link_to,:number_to_currency,  to: :@view
  def initialize(view, agencyid)
    @view = view
    @agencyid = agencyid
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: Producingagency.find_all_by_generalagency_id(@agencyid).count,
        iTotalDisplayRecords: producers.total_count,
        aaData: data
    }
  end

  private

  def data

    producers.map do |producer|
      [
          link_to(producer.agency_name, producer),
          h(producer.address_1),
          h(producer.city),
          h(producer.status),
          number_to_currency(producer.openbalance)
      ]
    end
  end

  def producers
    @producers ||= fetch_producers
  end

  def fetch_producers
    producers = Producingagency.order("#{sort_column} #{sort_direction}").find_all_by_generalagency_id(@agencyid)
    producers =  Kaminari.paginate_array(producers).page(page).per(per_page)

    if params[:sSearch].present?
      producers = producers.search(params[:sSearch], :page=>1)

    end
    producers
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[agency_name address_1 city status openbalance]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end