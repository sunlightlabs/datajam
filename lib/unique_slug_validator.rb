class UniqueSlugValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    existing_id = nil
    if value
      [Event, Page].each do |model|
        # TODO: dirty dirty hack to workaround the stupid things mogoid-slug does
        value = object.slug || object.send(:find_unique_slug) if object.is_a?(Event)
        existing = model.find_by_slug(value)
        existing_id = existing._id if existing
      end
      if route_already_taken?(value) && object._id != existing_id
        object.errors[attribute] << (options[:message] || "is already taken")
      end
    end
  end

  def route_already_taken?(route)
    # This cannot use rails routing because we serve from redis via middleware,
    # and Rails recognizes all routes due to custom 404 handling
    route = route.gsub(/(^\/|\/$)/, '')
    return true unless (route =~ /^(#{Datajam.reserved_routes.join('|')})/).nil?
    !! Event.where(slug: route).any? ||
       Page.where(slug: route).any? rescue false
  end
end
