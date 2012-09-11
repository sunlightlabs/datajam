class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :set_layout

  private

  def filter_and_sort(collection)
    collection = filter_if_present(collection, params[:q], params[:field])
    sort_if_present(collection, params[:sort])
  end

  def filter_if_present(collection, query, field)
    query && field ? collection.where(field.to_sym => /#{query}/i) : collection
  end

  def sort_if_present(collection, sort_by = false)
    if sort_by
      collection.options[:sort].pop if collection.options[:sort] # Removes previous sorting
      field, order = sort_by.split(":")

      if order == "desc"
        collection.desc(field.to_sym)
      else
        collection.asc(field.to_sym)
      end
    else
      collection
    end
  end

  def set_layout
    if request.xhr?
      false
    else
      request.path =~ /^(\/users|\/admin)/ ? "admin" : "application"
    end
  end

  def render_if_ajax(*args)
    render *args if request.xhr?
  end
end
