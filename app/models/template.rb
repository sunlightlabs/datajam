class Template
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :name,           type: String
  field :template,       type: String
  field :template_type,  type: String, default: 'internal'
  field :custom_fields,  type: Array

  slug :name, permanent: true

  has_many :events

  scope :event_templates, any_of({template_type: 'internal'}, {template_type: 'external'})
  scope :internal_templates, where(template_type: 'internal')
  scope :external_templates, where(template_type: 'external')

  before_save :set_custom_fields
  after_save :cache_template

  # Mongoid::Slug changes this to `self.slug`. No thanks.
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
    redis = Redis::Namespace.new(Rails.env.to_s, :redis => Redis.new)

    case self.template_type.downcase
    when 'site'
      site_template = Nokogiri::HTML(self.template)
      root_cached = false

      # Cache all events.
      Event.upcoming.each do |event|

        # Populate the template with the event's values.
        template = Nokogiri::HTML(event.template.template)
        unless event.template_data.nil?
          template.css('[id*=datajam]').each do |el|
            field = el["id"].gsub!('datajam','')
            el.content = event.template_data[field]
          end
        end

        # Cache the event page.
        site_template.at_css('#datajamEvent').inner_html = template.to_html
        redis.set '/' + event.slug, site_template.to_html

        # Cache the root event if this is the first upcoming event.
        if !root_cached
          redis.set '/', site_template.to_html
          root_cached = true
        end
      end

      # TODO: Cache all static pages.
    when 'internal'
      # Cache all events that use this template.

    when 'external'
      # Cache all events that use this template.

    end

  end

end
