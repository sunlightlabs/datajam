class Template
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :template, type: String
  field :custom_fields, type: Array

  has_many :events

  before_save :set_custom_fields
  after_save :cache_template

  scope :site_templates, where(:name.ne => 'Site')

  protected

  def cache_template
    redis = Redis::Namespace.new(Rails.env.to_s, :redis => Redis.new)

    case self.name.downcase
    when 'site'
      redis.set '/', self.template
    end
  end

  def set_custom_fields
    doc = Nokogiri::HTML(self.template)
    self.custom_fields = []

    doc.css('[id*=datajam]').each do |el|
      field = el["id"].gsub!('datajam','')
      self.custom_fields << field
    end
  end

end
