class Template
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include ActionView::Helpers::TextHelper

  CONTENT_AREAS_REGEXP = /\{\{([\w ]+):([\w ]+) \}\}/
  HANDLEBARS_REGEXP = /\{\{([\w ]+)\}\}/

  field :name,           type: String
  field :template,       type: String
  field :type,           type: String
  field :custom_fields,  type: Array,  default: []
  field :custom_areas,   type: Hash,   default: {}

  slug :name, permanent: true

  before_save :check_integrity, :set_custom_fields, :set_custom_areas

  before_destroy do
    if !can_be_deleted?
      event = self.events.first
      event_count = self.events.count

      error_message =  "Template could not be deleted. '#{event.name}' "
      error_message << "and #{event_count - 1} other #{pluralize(event_count, 'event')} " if event_count > 1
      error_message << "#{pluralize(event_count, 'depends', 'depend')} on it."

      errors.add(:base, error_message)
    end
    errors.blank?
  end

  def can_be_deleted?
    !self.events(true).any?
  end

  def name_is_editable?
    true
  end

  # `Mongoid::Slug` changes this to `self.slug`. No thanks.
  def to_param
    self.id.to_s
  end

  # Provide a wrapper to the call to the templating engine.
  def render_with(data)
    Handlebars.compile(self.template).call(data)
  end

  protected

  def check_integrity
    template = self.template.gsub(CONTENT_AREAS_REGEXP, '')
    Handlebars.compile(template)
  rescue => e
    puts e.message
    puts e.backtrace.join("\n")
    errors.add(:base, "There are errors in your template")
    errors.blank?
  end

  # Find fields enclosed in `{{handlebars}}`
  def set_custom_fields
    found_fields = self.template.scan(HANDLEBARS_REGEXP).flatten
    found_fields.each { |f| f.strip! }
    %w{ content head_assets body_assets event_reminder }.each do |reserved_word|
      found_fields.delete(reserved_word)
    end
    self.custom_fields = found_fields
  end

  # Find content areas of the format `{{ content_area_type: Name }}`
  def set_custom_areas
    self.custom_areas = {}
    self.template.scan(CONTENT_AREAS_REGEXP) do |type, name|
      self.custom_areas[name.strip!] = type.strip!
    end
  end
end
