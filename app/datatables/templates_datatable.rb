class TemplatesDatatable < ActionController::Base
  delegate :params, :h, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: templates.total_count,
        iTotalDisplayRecords: templates.total_count,
        aaData: data
    }
  end

  private

  def data
    templates.map do |template|
    [
      h(template.id),
      h(template.name),
      h(template.content),
      '<div class="editTemplateBtn btn">Edit</div> <div class="deleteTemplateBtn btn btn-danger">Delete</div>'
    ]
    end
  end

  def templates
    @templates ||= fetch_templates
  end

  def fetch_templates
    templates = MessageTemplate.all()

    templates = Kaminari.paginate_array(templates).page(page).per(per_page)

    templates
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[id name content]

    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end