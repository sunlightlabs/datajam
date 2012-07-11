module AdminHelper
  RECORDS_PER_PAGE = 10

  def table_for(collection, headers, &row)
    sorted_by = collection.options.fetch(:sort, []).first
    collection = get_for_page(collection)

    if collection.blank?
      content_tag(:p, "Nothing to show yet, why don't you go ahead and create something?", class: "empty")
    else
      render "shared/table",
        headers: Array(headers),
        collection: Array(collection),
        sorted_by: sorted_by,
        generator: row
    end
  end

  def simple_table_for(collection, headers, &row)
    if collection.empty?
      content_tag(:p, "Nothing to show yet, why don't you go ahead and create something?", class: "empty")
    else
      render "shared/simple_table",
      headers: Array(headers),
      collection: Array(collection),
      generator: row
    end
  end

  def search_box(input_name)
    render 'shared/form', search_name: input_name
  end

  def get_for_page(collection, records = RECORDS_PER_PAGE)
    from = (page_number - 1) * records
    to = from + records
    collection[from..to]
  end

  def sort_icon(order)
    direction = order == :asc ? "down" : "up"
    content_tag(:i, ' ', class: "icon-chevron-#{direction}")
  end

  def link_to_if_sym_to_sort(str, sorted_by)
    # TODO: Refactor this
    return str if !str.is_a?(Symbol)

    field, order = sorted_by
    header = str.to_s.gsub('_', ' ').capitalize
    link  = "#{header} ".html_safe
    link << sort_icon(order).html_safe if field == str
    new_order = order == :desc ? :asc : :desc

    link_to(link, "?sort=#{str}:#{new_order}", data: { pjax: '.ajax-table'} )
  end

  def delete_button(path, options={})
    text = options.fetch(:label, "Delete")
    class_name = "btn btn-danger btn-small #{options.delete(:class)}".strip
    button_to text, path, options.reverse_merge(method: :delete, class: class_name)
  end

  def text_for_submit(record)
    (record.new? ? "Create" : "Update") + " " + record.class.to_s.underscore.humanize
  end

  def page_number
    params.fetch(:page, 1).to_i
  end
end
