
class ClientsDatatable

  delegate :params, :h, :link_to,:number_to_currency,  to: :@view
  def initialize(view, agencyid)

    @view = view
    @agencyid = agencyid


  end

  def as_json(options = {})

    clienttotal = Client.find_all_by_agency_id(@agencyid).count


    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: clienttotal,
        iTotalDisplayRecords: clients.total_count,
        aaData: data
    }
  end

  private

  def data

    clients.map do |client|
      [
          link_to(client.fullname, client),
          h(client.activepolcount),
          h(number_to_currency(client.activepremium) ),
          h(number_to_currency(client.openbalance))
      ]
    end


  end

  def clients
    @clients ||= fetch_clients
  end

  def fetch_clients

    #sorting = sort_column+" "+ sort_direction

=begin
    if sort_column == "fullname"
      clients = Client.find_all_by_agency_id(@agencyid)
      if sort_direction == 'asc'
        clients.sort_by!(&:fullname)
      else
        clients.sort_by!(&:fullname).reverse!
      end

    elsif sort_column == "activepolcount"

      clients = Client.find_all_by_agency_id(@agencyid)

      if sort_direction == 'asc'
        clients.sort_by!(&:activepolcount)
      else
        clients.sort_by!(&:activepolcount).reverse!
      end
    elsif sort_column == "activepremium"

      clients = Client.find_all_by_agency_id(@agencyid)

      if sort_direction == 'asc'
        clients.sort_by!(&:activepremium)
      else
        clients.sort_by!(&:activepremium).reverse!
      end
    elsif sort_column == "openbalance"

      clients = Client.find_all_by_agency_id(@agencyid)

      if sort_direction == 'asc'
        clients.sort_by!(&:openbalance)
      else
        clients.sort_by!(&:openbalance).reverse!
      end

    else

       clients = Client.order(sorting).find_all_by_agency_id(@agencyid)

    end
=end

    clients = Client.find_all_by_agency_id(@agencyid)
    clients.sort_by!(&:fullname)
    clients =  Kaminari.paginate_array(clients).page(page).per(per_page)
    #print clients

    if params[:sSearch].present?
      clients = clients.search(params[:sSearch], :page=>1)

    end


    clients
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column

      #columns = %w[fullname activepolcount activepremium openbalance]


    #columns[params[:iSortCol_0].to_i]
  end

  def sort_direction

    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end