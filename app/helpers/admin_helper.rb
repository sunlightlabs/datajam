module AdminHelper
  def table_for(collection, headers, &row)
    render "shared/table", headers: Array(headers), collection: Array(collection), generator: row
  end

  def delete_button(path, options={})
    text = options.fetch(:label, "Delete")
    class_name = "btn btn-danger btn-small #{options.delete(:class)}".strip
    button_to text, path, options.reverse_merge(method: :delete, class: class_name)
  end
end
