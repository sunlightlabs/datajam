class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :name,           type: String
  field :scheduled_at,   type: Time
  field :status,         type: String,  default: 'Upcoming'
  field :template_data,  type: Hash,    default: {}
  field :activities,     type: Hash,    default: {}

  slug :name, permanent: true

  validates_presence_of :name

  belongs_to :event_template
  has_and_belongs_to_many :embed_templates
  has_many :content_areas
  has_and_belongs_to_many :users

  before_save :update_template_data, :generate_content_areas

  after_save do
    Cacher.cache_events([self])
  end

  scope :upcoming, where(status: 'Upcoming').order_by([[:scheduled_at, :asc]])

  # Mongoid::Slug changes this to `self.slug`. Undo that.
  def to_param
    self.id.to_s
  end

  # Render the HTML for an event page
  def render
    rendered_content = preprocess_template(self.event_template).render_with(self.template_data)
    SiteTemplate.first.render_with({ content: rendered_content,
                                     head_assets: HEAD_ASSETS,
                                     body_assets: BODY_ASSETS})
  end

  # Render the HTML for an embed
  def rendered_embeds
    embeds = {}
    self.embed_templates.each do |embed_template|
      data = self.template_data.merge({head_assets: HEAD_ASSETS, body_assets: BODY_ASSETS})
      embeds[embed_template.slug] = preprocess_template(embed_template).render_with(data)
    end
    embeds
  end

  # Convert content areas from Handlebars to HTML
  def preprocess_template(template)
    self.content_areas.each do |content_area|
      template.template.gsub!(/\{\{([\w ]*):([\w ]*) \}\}/, content_area.render)
    end
    template
  end

  protected

  def update_template_data
    self.template_data ||= {}
    fresh_fields = []

    # Find all custom fields from all templates.
    templates = ([self.event_template] + self.embed_templates).compact
    templates.each do |t|
      t.custom_fields.each do |f|
        # Add to hash if needed.
        self.template_data[f] ||= ''
        # Cache the field name for the deletion step below.
        fresh_fields << f
      end if t.custom_fields
    end

     # Remove custom fields that are no longer relevant.
    self.template_data.delete_if { |k,v| !fresh_fields.include?(k) }
  end

  def generate_content_areas
    ([event_template] + embed_templates).each do |template|
      template.custom_areas.each do |name, area_type|
        unless ContentArea.exists?(conditions: { event_id: self.id, name: name, area_type: area_type })
          self.content_areas << ContentArea.create(name: name, type: area_type)
        end
      end
    end
  end

end
