module AdminHelper
  def table_for(collection, headers, &row)
    render "shared/table", headers: Array(headers), collection: Array(collection), generator: row
  end
end
