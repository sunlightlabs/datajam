class Template
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :name,           type: String
  field :template,       type: String
  field :custom_fields,  type: Array,  default: []
  field :custom_areas,   type: Hash,   default: {}

  slug :name, permanent: true

  before_save :set_custom_fields, :set_custom_areas

  # `Mongoid::Slug` changes this to `self.slug`. No thanks.
  def to_param
    self.id.to_s
  end

  # Provide a wrapper to the call to the templating engine.
  def render_with(data)
    Handlebars.compile(self.template).call(data)
  end

  protected

  # Find fields enclosed in `{{handlebars}}`
  def set_custom_fields
    found_fields = self.template.scan(/\{\{([\w ]*)\}\}/).flatten
    found_fields.each { |f| f.strip! }
    %w{ content head_assets body_assets }.each do |reserved_word|
      found_fields.delete(reserved_word)
    end
    self.custom_fields = found_fields
  end

  # Find content areas of the format `{{ content_area_type: Name }}`
  def set_custom_areas
    self.custom_areas = {}
    self.template.scan(/\{\{([\w ]*):([\w ]*) \}\}/) do |type, name|
      self.custom_areas[name.strip!] = type.strip!
    end
  end
end
