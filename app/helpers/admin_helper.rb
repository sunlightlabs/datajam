module AdminHelper
  RECORDS_PER_PAGE = 15

  def table_for(collection, headers, &row)
    buttons = pagination_buttons(collection)
    collection = get_for_page(collection)

    if collection.empty?
      if !page_number.zero?
        show_pagination("less")
      else
        content_tag(:p, "Nothing to show yet, why don't you go ahead and create something?")
      end
    else
      render "shared/table",
        headers: Array(headers),
        collection: Array(collection),
        generator: row,
        pagination_buttons: buttons
    end
  end

  def get_for_page(collection, records = RECORDS_PER_PAGE)
    collection.skip(page_number * records).take(records)
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
    params.fetch(:page, 0).to_i
  end

  def show_pagination(action = "more")
    page = action == "more" ? page_number + 1 : page_number - 1
    page_link = "#{request.path}?page=#{page}"
    content_tag(:a, "Show #{action}",
                class: "btn #{action}",
                data: { pjax: "#table-main" },
                href: page_link)
  end

  def pagination_buttons(collection)
    amount = page_number + 1 * RECORDS_PER_PAGE
    show_more = amount < collection.size

    pagination  =  ''
    pagination << show_pagination("less") unless page_number < 1
    pagination << show_pagination("more") if show_more
    pagination.html_safe
  end
end
