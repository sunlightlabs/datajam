class UniqueSlugValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    [Event, Page].each do |model|
      if !object.is_a?(model) && !!model.find_by_slug(value)
        object.errors[attribute] << (options[:message] || "The slug it's already taken")
      end
    end
  end
end
