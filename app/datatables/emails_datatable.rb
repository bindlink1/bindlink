class EmailsDatatable < ActionController::Base
  delegate :params, :h, to: :@view

  def initialize(view, current_agent)
    @view = view
    @current_agent = current_agent
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: emails.total_count,
        iTotalDisplayRecords: emails.total_count,
        aaData: data
    }
  end

  private

  def data
    emails.map do |email|
    [
      h(email.id),
      h(email.created_at),
      h(email.subject),
      h(email.from),
      h(email.to),
      h(email.body),
      "<a href=\"https://bindlink.com/download_document/#{email.document_id}\">#{email.document_id}</a>"
    ]
    end
  end

  def emails
    @emails ||= fetch_emails
  end

  def fetch_emails
    sorting = sort_column+" "+ sort_direction

    if @current_agent.is_admin?
      emails = Email.order(sorting)
        else
      emails = Email.order(sorting)#.where("\"from\"='#{current_agent.email}'")
    end

    if params[:sSearch].present?
      query = "subject like '%#{params[:sSearch]}%'" 
      emails = emails.where(query)
    end

    emails = Kaminari.paginate_array(emails).page(page).per(per_page)

    emails
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[id created_at subject from to body document_id]

    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end