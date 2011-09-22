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
  after_save :cache_template

  # `Mongoid::Slug` changes this to `self.slug`. No thanks.
  def to_param
    self.id.to_s
  end

  def self.site_template
    where(template_type: 'site').first
  end

  protected

  def set_custom_fields
    doc = Nokogiri::HTML(self.template)
    self.custom_fields = []

    doc.css('[id*=datajam]').each do |el|
      field = el["id"].gsub!('datajam','')
      self.custom_fields << field
    end
  end

  def cache_template

  end

end
