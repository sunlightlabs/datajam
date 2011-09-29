class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :name,           type: String
  field :scheduled_at,   type: Time
  field :status,         type: String,  default: 'Upcoming'
  field :template_data,  type: Hash
  field :activities,     type: Hash

  slug :name, permanent: true

  validates_presence_of :name

  belongs_to :event_template
  has_and_belongs_to_many :embed_templates
  has_and_belongs_to_many :users

  before_save :update_template_data

  after_save do
    Cacher.cache_events([self])
  end

  scope :upcoming, where(status: 'Upcoming').order_by([[:scheduled_at, :asc]])

  # Mongoid::Slug changes this to `self.slug`. Undo that.
  def to_param
    self.id.to_s
  end

  protected

  def update_template_data
    self.template_data ||= {}
    fresh_fields = []

    # Find all custom fields from all templates.
    templates = [self.event_template] + self.embed_templates
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

end
