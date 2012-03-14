module AdminHelper
  def table_for(collection, headers, &row)
    if collection.empty?
      content_tag(:p, "Nothing to show yet, why don't you go ahead and create something?")
    else
      render "shared/table", headers: Array(headers), collection: Array(collection), generator: row
    end
  end

  def delete_button(path, options={})
    text = options.fetch(:label, "Delete")
    class_name = "btn btn-danger btn-small #{options.delete(:class)}".strip
    button_to text, path, options.reverse_merge(method: :delete, class: class_name)
  end
end
