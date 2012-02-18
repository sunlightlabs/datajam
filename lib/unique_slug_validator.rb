class UniqueSlugValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    if value
      [Event, Page].each do |model|
        # TODO: dirty dirty hack to workaround the stupid things mogoid-slug does
        value = object.slug || object.send(:find_unique_slug) if object.is_a?(Event)
        if route_already_taken?(value) || !object.is_a?(model) && !!model.find_by_slug(value)
          object.errors[attribute] << (options[:message] || "it's already taken")
        end
      end
    end
  end

  def route_already_taken?(route)
    route = '/' + route if route[0] != '/'
    !!Rails.application.routes.recognize_path(route) rescue false
  end
end
