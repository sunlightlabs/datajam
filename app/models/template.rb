class Template
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :name,           type: String
  field :template,       type: String
  field :custom_fields,  type: Array

  slug :name, permanent: true

  has_many :events

  before_save :set_custom_fields

  # `Mongoid::Slug` changes this to `self.slug`. No thanks.
  def to_param
    self.id.to_s
  end

  protected

  # Find fields enclosed in `{{handlebars}}`
  def set_custom_fields
    found_fields = self.template.scan(/\{\{([\w ]*)\}\}/).flatten
    found_fields.delete("content")
    found_fields.each { |f| f.strip! }
    self.custom_fields = found_fields
  end

end
