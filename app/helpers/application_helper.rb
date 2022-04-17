module ApplicationHelper
  class MenuTabBuilder < TabsOnRails::Tabs::Builder
    def open_tabs(options = {})
      @context.tag("ul", options, open = true)

    end

    def close_tabs(options = {})


      "</ul>".html_safe

    end

    def tab_for(tab, name, options, item_options = {})
      item_options[:class] = (current_tab?(tab) ? 'active' : '')

      @context.content_tag(:li, item_options) do
        @context.link_to(name, options)
      end

    end


  end

  #used to put devise login in a partial
  def resource_name
    :agent
  end

  def resource
    @agent ||= Agent.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:agent]

    #end
  end

  def format_phone(phone)
    return phone if format.blank?
    groupings = format.scan(/d+/).map { |g| g.length }
    groupings = [3, 3, 4] unless groupings.length == 3
    ActionController::Base.helpers.number_to_phone(
        phone,
        :area_code => format.index('(') ? true : false,
        :groupings => groupings,
        :delimiter => format.reverse.match(/[^d]/).to_s
    )
  end

  def title(page_title)
    content_for :title, page_title.to_s
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id

    fields = f.fields_for association, :index=>id.to_s  do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to( '#', class: "add_fields btn btn-info", data: {id: id, fields: fields.gsub("\n", "")}) do
    raw('<i class="icon-plus icon-white"></i>' + name)
    end

  end

end
